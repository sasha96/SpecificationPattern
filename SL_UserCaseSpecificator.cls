public class SL_UserCaseSpecificator {
   
    public interface ISpecification{
        Boolean isSatisfiedBy( SL_User usr, Case cs );
        Schema.sObjectField getFieldForUpdate();
    }

    public abstract class Specification implements ISpecification{
        
        public SL_User.BusinessRole role;
        List<Id> caseRecordTypeIds;
        Schema.sObjectField field;
        
        public abstract Boolean isSatisfiedBy( SL_User usr, Case cs );
        
        public Schema.sObjectField getFieldForUpdate(){
            return this.field;
        }
    }

    public class EnrollmentAssociateCoordinator extends Specification{

        public EnrollmentAssociateCoordinator(){
            this.role = SL_User.BusinessRole.ENROLLMENT_ASSOCIATE_COORDINATOR;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_EMLTC, SL_CaseRepository.RECTYPEID_MAP, SL_CaseRepository.RECTYPEID_Medicare };
            this.field = Case.EnrollmentAssociateCoordinator__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( this.role ) != -1 && ( SL_CaseService.isEnrollmentRecordType( cs ) || cs.RecordTypeId == SL_CaseRepository.RECTYPEID_Medicare );
        }
    }

    public class IntakeRepresentative extends Specification{

        public IntakeRepresentative(){
            this.role = SL_User.BusinessRole.INTAKE_REPRESENTATIVE;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_EMLTC, SL_CaseRepository.RECTYPEID_MAP };
            this.field = Case.IntakeRepresentative__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && SL_CaseService.isEnrollmentRecordType( cs );
        }
    }

    public class IntakeRn extends Specification{

        public IntakeRn(){
            this.role = SL_User.BusinessRole.INTAKE_RN;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_EMLTC, SL_CaseRepository.RECTYPEID_MAP };
            this.field = Case.IntakeRN__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && SL_CaseService.isEnrollmentRecordType( cs );
        }        
    }

    public class IntakeCoordinator extends Specification{

        public IntakeCoordinator(){
            this.role = SL_User.BusinessRole.INTAKE_COORDINATOR;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_EMLTC, SL_CaseRepository.RECTYPEID_MAP };
            this.field = Case.IntakeCoordinator__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && SL_CaseService.isEnrollmentRecordType( cs );
        }  
    }

    public class IntakeFieldCoordinator extends Specification{

        public IntakeFieldCoordinator(){
            this.role = SL_User.BusinessRole.INTAKE_FIELD_COORDINATOR;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_EMLTC, SL_CaseRepository.RECTYPEID_MAP };
            this.field = Case.IntakeFieldCoordinator__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && SL_CaseService.isEnrollmentRecordType( cs );
        }         
    }

    public class IntakeUASReviewer extends Specification{

        public IntakeUASReviewer(){
            this.role = SL_User.BusinessRole.INTAKE_UAS_REVIEWER;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_EMLTC, SL_CaseRepository.RECTYPEID_MAP };
            this.field = Case.IntakeUASReviewer__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && SL_CaseService.isEnrollmentRecordType( cs );
        }  
    }

    public class BenefitEligibilityCoordinator extends Specification{
        
        public BenefitEligibilityCoordinator(){
            this.role = SL_User.BusinessRole.BENEFITS_ELIGIBILITY_COORDINATOR;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_BENEFITS_ELIGIBILITY };
            this.field = Case.BenefitsEligibilityCoordinator__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && cs.RecordTypeId == SL_CaseRepository.RECTYPEID_BENEFITS_ELIGIBILITY;
        }
    }

    public class CDPASCoordinator extends Specification{
        
        public CDPASCoordinator(){
            this.role = SL_User.BusinessRole.CDPAS_COORDINATOR;
            this.caseRecordTypeIds = new List<Id>{ SL_CaseRepository.RECTYPEID_CDPAS };
            this.field = Case.CDPASCoordinator__c;
        }
        
        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            return usr.getBusinessRoles().indexOf( role ) != -1 && cs.RecordTypeId == SL_CaseRepository.RECTYPEID_CDPAS;
        }
    }

    public class CompositiveSpecification extends Specification{

        private List<Specification> specifications;
        private List<Schema.sObjectField> satisfiedFields;

        public CompositiveSpecification(){
            this.specifications = new List<Specification>{
                new EnrollmentAssociateCoordinator(),
                new IntakeRepresentative(),
                new IntakeRn(),
                new IntakeCoordinator(),
                new IntakeFieldCoordinator(),
                new IntakeUASReviewer(),
                new BenefitEligibilityCoordinator(),
                new CDPASCoordinator()
            };
        }

        public override Boolean isSatisfiedBy( SL_User usr, Case cs ){
            satisfiedFields = new List<Schema.sObjectField>();
            for( Specification spec : this.specifications ){
                if( spec.isSatisfiedBy( usr, cs ) ){
                    this.satisfiedFields.add( spec.getFieldForUpdate() );
                }
            }

            return !satisfiedFields.isEmpty();
        }

        public List<Schema.sObjectField> getFieldForSetup(){
            return this.satisfiedFields;
        }
    }
}