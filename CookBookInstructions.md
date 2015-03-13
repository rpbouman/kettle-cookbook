# Get the cookbook #

You can either download file kettle-cookbook.zip or extract the code from the Subversion source repository.

# Usage #

Kettle Cookbook works by running a standard PDI 4.x job with Kitchen.
Suppose you extracted the Cookbook files in folder: /parking/kettle-cookbook

From your PDI distribution run the job called **pdi/document-folder.kjb**. The job expects two parameters:
  * **INPUT\_DIR** : the location of your source transformations (.ktr) and jobs (.kjb)
  * **OUTPUT\_DIR** : the folder where you want to store the documentation results.

If you run Kettle-cookbook using Kettle 4 (or higher), the contents of the INPUT\_DIR will be examined recursively. It has been reported that running it with kettle 3.2 will only scan the INPUT\_DIR itself, not its subdirectories.

If you run the job in spoon, you should provide values for the parameters in the grid at the left side of the launch dialog.

To run the job from the commandline, cd into the kettle home directory, and use a command line like this:

```
sh kitchen.sh -file:/parking/kettle-cookbook/pdi/document-folder.kjb -param:"INPUT_DIR"=/project/dwh/kettle/ -param:"OUTPUT_DIR"=/tmp/output
```

Please note that Kettle 4.0.0 has a bug that prevents you from using parameters on the linux command line. See: http://jira.pentaho.com/browse/PDI-4219. Download 4.0.1 or higher to fix this issue.

Please note that Windows users should use quotes around the entire parameter/value pair.
For more information on using parameters see http://wiki.pentaho.com/display/EAI/Named+Parameters

That's all there is to it.

Enjoy the Kettle Cookbook!