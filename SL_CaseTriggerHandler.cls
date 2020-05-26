
public without sharing class Example {

    private void validateOwnerIsChanged( Map<Id, Case> oldMap, Map<Id, Case> newMap ){

        SL_UserCaseSpecificator.CompositiveSpecification specification = new SL_UserCaseSpecificator.CompositiveSpecification();

        if( specification.isSatisfiedBy( owner, cs ) ){
            List<Schema.sObjectField> fields = specification.getFieldForSetup();
            for( Schema.sObjectField field : fields ){
                checkAndAddedCaseToList( // do some logic here );
            }                      
        }
    }
}