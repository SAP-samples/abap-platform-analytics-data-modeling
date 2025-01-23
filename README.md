[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/abap-platform-analytics-data-modeling)](https://api.reuse.software/info/github.com/SAP-samples/abap-platform-analytics-data-modeling)

# ABAP Platform Examples for Analytical Data Modeling
The ABAP Platform Examples for Analytical Data Modeling provide an analytical data model that is based on the ABAP Flight Reference Scenario. It allows to get  familiar with modern, ABAP-CDS based analytical data modeling and provides examples for the most prominent features of the Embedded Analytics functionality in the ABAP Platform. You can either use the provided data model as is or build your own data model using parts of the examples.

## Requirements
Make sure to fulfill the following prerequisites:
* You have access to a recent ABAP Platform Cloud instance.
* You have downloaded and installed the most recent version of ABAP Development Tools (ADT). See the [installation page](https://tools.hana.ondemand.com/#abap). 
* You have created an ABAP Cloud Project in ADT that allows you to access your ABAP Environment instance.
* You have installed the [abapGit](https://github.com/abapGit/eclipse.abapgit.org) plug-in for ADT from the [ABAPGit update site](http://eclipse.abapgit.org/updatesite/).
* You have used abapGit to import the [ABAP Flight Reference Scenario](https://github.com/SAP-samples/abap-platform-refscen-flight) for ABAP Platform Cloud as described in the resrective [README](https://github.com/SAP-samples/abap-platform-refscen-flight/blob/ABAP-platform-cloud/README.md).

## Download and Installation
### Download
Use the abapGit plug-in to import the <em>ABAP Platform Examples for Analytical Data Modeling</em> by executing the following steps:
1. In your ABAP cloud project, create the ABAP package `/DMO/ANA_FLIGHT` (using the superpackage `/DMO/SAP`) as the target package for the demo content to be downloaded (leave the suggested values unchanged when following the steps in the package creation wizard).
2. To add the <em>abapGit Repositories</em> view to the <em>ABAP</em> perspective, click `Window` > `Show View` > `Other...` from the menu bar and choose `abapGit Repositories`.
3. In the <em>abapGit Repositories</em> view, click the `+` icon to clone an abapGit repository.
4. Enter the following URL of this repository: `https://github.com/SAP-samples/abap-platform-analytics-data-modeling.git` and choose <em>Next</em>.
5. Enter the newly created package `/DMO/ANA_FLIGHT` as the target package and choose <em>Next</em>.
6. Create a new transport request that you only use for this demo content installation (recommendation) and choose <em>Finish</em> to link the Git repository to your ABAP cloud project. The repository appears in the abapGit Repositories View with status <em>Linked</em>.
7. Right-click on the new ABAP repository and choose `pull` to start the cloning of the repository contents. Note that this procedure may take a few minutes. 
8. Once the cloning has finished, the status is set to `Pulled Successfully`. (Refresh the `abapGit Repositories` view to see the progress of the import).
9. Refresh the project tree.

As a result of the installation procedure above, the ABAP system creates an inactive version of all artifacts from the demo content and adds the sub package `/DMO/ANA_FLIGHT_QUERY` to the target package that contains additional analytical queries that demonstrate various features of embedded analytics.

### Configuration
To activate all development objects from the `/DMO/ANA_FLIGHT` package: 
1. Click the mass-activation icon (<em>Activate Inactive ABAP Development Objects</em>) in the toolbar.  
2. In the dialog that appears, select all development objects in the transport request (that you created for the demo content installation) and choose `Activate`. (The activation may take a few minutes.)

To fill the demo database tables: 
1. Expand the package structure in the Project Explorer `/DMO/FLIGHT_LEGACY` > `Source Code Library` > `Classes`.
2. Open the data generator class `/DMO/CL_FLIGHT_DATA_GENERATOR` and go to `lcl_flight_data_generator`.
3. Change the used constants in METHOD `build_connection_recurrency` to `cv_days_between_4weeks` to get data that is better suited for analytical purposes.
4. Mass Activate.
5. Now press `F9` to run the generator as Console Application.

NOTE: Even if you did run the generator before, you need to run the generator again after having installed the <em>ABAP Platform Examples for Analytical Data Modeling</em> to get additional example data e.g. for the hierarchies.

To be able to use currency conversion:
1. Create a new package of your choice, e.g. `ZCURR_CONV`.
2. Import the Github repo `https://github.com/SAP-samples/cloud-abap-exchange-rates` into the new package.
3. Mass Activate.
4. Check https://github.com/SAP-samples/cloud-abap-exchange-rates/blob/main/README.md for instructions how to use.
5. Try the XML import from the European Central Bank via `zcl_ecb_exchange_rates_xml`.
6. As an alternative implement class zcl_ecb_exchange_rates_xml and run it in the console. The code of the class can be found in the text file zcl_ecb_exchange_rates_xml.aba.

NOTE: The namespace /DMO/ is reserved for the demo content. Apart from the downloaded demo content, do not use the namespace /DMO/ and do not create any development objects in the downloaded packages. You can access the development objects in /DMO/ from your own namespace.

## Test the ABAP Platform Examples
1. Make sure all development objects are fully activated.
2. Open `/DMO/ANA_C_AirportCapaQry` in ADT.
3. Right-click `/DMO/ANA_C_AirportCapaQry` and choose `Open With` -> `Data Preview`.
4. A browser window should open that displays a multi-dimensional dat preview of the analytical query.

<!--  ## Known Issues
You may simply state "No known issues.
-->
## How to obtain support
This project is provided "as-is": there is no guarantee that [raised issues](https://github.com/SAP-samples/abap-platform-analytics-data-modeling/issues) will be answered or addressed in future releases.
For additional support, please [ask questions in SAP Community](https://answers.sap.com/questions/ask.html).

## License
Copyright (c) 2025 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
