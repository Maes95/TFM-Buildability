# Steps to reproduce Taxonomy Development

## Set Up:

1. Create your own copy of taxonomy template (use ```Taxononomy-Template.xslx```)
2. Download and run the Docker image with all results (take a bit time to download):
    ```docker run -it -p 8888:8888 maes95/taxonomy:java-7```
3. Inside Docker container, run:
	```./runJupyterNotebook.sh```
4. Open: ```http://localhost:8888``` and enter the token that you see in terminal to set up Jupyter Notebook.
5. There are 3 levels of difficulty when you examine a trace:
    * **Easy** -> You can get Dimensions/Characteristics just from trace
    * **Medium** -> Insufficient trace information, you should goto project’s notebook to inspect the full log. Navigate in Jupyter Notebook’s page to ```/bugs/analysis/_notebooks/``` and open the project. Go Kernel>Restart and Run All in menu. Find this line: ```pa.view_log_by_hash(errors,<hash_id>, 0)``` and replace ```<hash_id>``` with the corresponding hash in table to see the log (pressing enter in the cell).
    * **Hard** -> Follow *Medium* steps and you see an output like this:

        ```Total commits: N | Current commit: <hash_id> | Log:```
    
        Copy commit hash and go to Docker container:
        * ```cd bugs/projects/<project>```
        * ```git checkout -f <commit_hash>```
        * Build project: ```../../configFiles/BuildFiles/build-<project>.sh```
        * See output. Use ```--stacktrace``` to get more info.


## Notes:

* You gona see in template 3 tabs, go to tab 3 *Iteration 1*.
* There are 80 log traces divided into 5 groups, corresponding to the 5 iterations. 
* For each iteration it is possible to use a conceptual (use previous knowledge of the domain) or empirical (only use the data) approach.
* Current docker container allow us to explore all projects’ notebooks, but only can build projects Lang, Math, Time and Closure. If you need to builds project spring-framework or  Mockito, use the following image (same usage, but with java-8)
        ```docker run -it -p 8888:8888 maes95/taxonomy:java-8```
* In base paper, they formally **define taxonomy as a set of dimensions**. Each dimension exiconsists of 2 or more characteristics:
    * An object to be classified cannot have two different characteristics in one dimension (mutual exclusive restriction).
    * Each object must have one of the characteristics of a dimension (collectively exhaustive restriction)
* In paper, they **define attributes** of a good taxonomy:
    * It's concise -> Not too many dimensions, the researcher must be able to have them in his head.
    * It is robust -> It has a minimum number of dimensions that allow you to clearly separate objects.
    * It is complete -> Classifies all objects within the domain
    Extendable -> Allows to include new dimensions when new objects appear
    * It's explanatory -> Allows you to easily classify an object without having all the details of it.
* In paper, they **define a series of End conditions**, which are the requirements to end a taxonomy. These can be objective (they are clearly defined in Table 2 of the paper) or subjective (the researcher estimates that the attributes cited above* have been satisfied).
* In paper, they **define the concept of meta-characteristic**, a highly understandable characteristic that gives rise to other characteristics. By way of example they propose the need to create a taxonomy of "mobile applications" and the meta-characteristics would be "Interaction at high level between the user and the application", where a dimension from this would be the communication, being the characteristics that the objects can take: informative, reporting or interactive. In our case, meta-characteristic is: *Fail origin/cause*

## Steps:
1. Take the a group N as a reference (16 traces)
2. Select an approach:
    * Empirical -> Select a trace and try to extract a dimension and its characteristics. Add its dimensions/characteristics to the table and classify the trace. Go to next trace and try to classify with current dimensions/characteristics. If can’t, create new dimensions/characteristics.
    * Conceptual: Add conceptual dimensions/characteristics to the table and classify each trace based on them. If you can't classify a trace, create new dimensions/characteristics.
3. If you create new dimensions with new characteristics, update traces of Iteration N according to them. 
4. If all traces on Iteration N were classify, duplicate tab/sheet and call it *Iteration N+1*. Then, go to *Iteration N+1* and repeat steps 1-3.
