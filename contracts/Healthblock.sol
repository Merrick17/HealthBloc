pragma solidity >= 0.5.0 <0.6.0 ;
pragma experimental ABIEncoderV2;
contract HealthBlock {
    uint Modulus = 10 ** 16;
    struct HospitalAdmin {
        string FullName ;
        address adminAdr ;
    }

    struct Doctor{
        string FullName ;
        string speciality ;
        uint    totalPatients ;
        uint Phone ;
        address docAdress;

    }
    struct Appointement {
        string date;
        uint docID;

    }
    struct Patient {
       string FullName ;
       uint age ;
       uint weight;
       string sexe ;
       uint phone ;
       address patientAdress;

    }
    HospitalAdmin private admin ;
    Doctor[] private doctorList ;
    Patient[] private patientList;
    mapping(address=>uint) doctors ;
    mapping(address=>uint) patients ;
    mapping(uint=>uint) doctTpatient ;
    mapping(uint=>uint)docPatientCount ;


    constructor() public
    {
      admin = HospitalAdmin("Super admin",msg.sender);

    }

    function generateRandomId(string memory _name) private view returns(uint)
    {
        uint rand = uint(keccak256(abi.encodePacked(_name)));
        return rand % Modulus;
    }

    modifier isAdmin()
    {
        require(msg.sender == admin.adminAdr,"sender is not an admin");
        _;
    }
    function addDoctor(string memory _fullName,string memory _speciality,uint  _phone,address _docAdress) public isAdmin {


        Doctor memory newDoc = Doctor(_fullName,_speciality,_phone,0,_docAdress);
        uint id = doctorList.push(newDoc)-1;
        doctors[_docAdress] = id;

    }
    function changeDocName(string memory _newName,address _docAdress)  public isAdmin
    {
        uint docId = doctors[_docAdress];
        doctorList[docId].FullName = _newName;

    }
     function changeDocPhone(uint  _newPhone,address _docAdress)  public isAdmin
    {
        uint docId = doctors[_docAdress];
        doctorList[docId].Phone = _newPhone;
    }

    function getDoctors() public view  returns(Doctor[] memory)
    {
        return doctorList ;
    }

    function addPatient(string memory _fullName,uint _age,int _weight,uint  _phone,address _patientAdress,string memory _sexe) public isAdmin {
        Patient memory  newpatient = Patient(_fullName,_age,uint(_weight),_sexe,_phone,_patientAdress);
        uint id = patientList.push(newpatient)-1;
        patients[_patientAdress] = id;

    }

    function assignPatient(uint _patientId,uint _doctorId) public isAdmin {
        doctTpatient[_doctorId] = _patientId;
        docPatientCount[_doctorId]++;
    }


    function  getPatientsByDoc(uint _doctorId) public view returns(Patient[] memory)
    {
        Patient[] memory newList = new Patient[](docPatientCount[_doctorId]);
        uint counter = 0;
        for(uint i = 0;i<patientList.length;i++)
        {
            if(doctTpatient[_doctorId]==i)
            {
                newList[counter] = patientList[i];
                counter++;

            }
        }
        return newList;
    }

    modifier isDoctor()
    {   uint currentId = doctors[msg.sender];
        require(doctorList[currentId].docAdress == msg.sender,"Sender must be a doctor");
        _;
    }


}