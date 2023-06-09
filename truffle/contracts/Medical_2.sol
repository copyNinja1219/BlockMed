// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
// Medical_2.sol
contract HealthManagement2 {
    struct Record{
        // string [] fileHashes;
        string docname;
        string fileHashes;
        string presciptions;
        string finalRemarks;
        address payable doctor_;
        uint256 timeStamp;
        uint256 amount;
        string patientName;
        address payable patientaddr;
        // MedicinePrescription[] medicines;    
    }

    struct Appointment{
        // address doctor_;
        bool status;
        address payable patient_;
        address payable doctor_;
        string patientName;
        string docname; 
        uint256 timeslot_;
        uint256 timeStart;
        uint256 timeEnd;
        uint256 id;
        bool paymentStatus;
    }

    // PATIENTS :
    struct Patient{
        string name;
        string email;
        address payable address_;
        uint256 phone;
        uint256 age;
        Record [] records_;
        string bloodgroup;
        uint256 dob;
        Appointment [] myAppointments;
        mapping (address => bool) recordAccess;
    }

    struct Doctor{
        string name;
        string email;
        string gender;
        string introduction;
        uint256 age;
        string location;
        address payable address_;
        // address [] doctorToPatient;
        uint256 basefee;
        uint256 starCount;
        uint256 totalPatients;
        Appointment []  appointments_;
        Record [] records_;
        // mapping( address => uint) myPatients;
    }

    address owner_;

    Appointment [] public allAppointments;
    address [] public alldoctors;
    address []public allPatientsList;

    mapping (address=>bool)public isDoctor;
    mapping (address => Doctor)public allDoctors;
    mapping( address => bool)public isPatient;
    // mapping( address => bool)public isDoctor;
    mapping( address => Patient) public allPatients;
    // mapping( address => Record []) public patientRecords;

    uint256 patientCount;
    uint256 doctorCount ;
    uint256 appointmentCount;

    
    function  addPatient(string memory name,uint256 phone,uint256 age,uint256 dob,string memory email) public {
        require(isPatient[msg.sender] == false,"You are already a patient ");
        isPatient[msg.sender] = true;
        allPatients[msg.sender].name= name;
        allPatients[msg.sender].address_= payable((msg.sender));
        allPatients[msg.sender].age= age;
        allPatients[msg.sender].phone= phone;
        allPatients[msg.sender].dob= dob;
        allPatients[msg.sender].email= email;
        allPatientsList.push(msg.sender);
        patientCount+=1;
    } 

    function getPatientDetails(address addr) public view returns(
        string memory name,string memory email,uint256  age, uint256  phone,
        string memory bloodgroup , uint256  dob ,Record [] memory recordss) {

        require(isPatient[addr],"You are not a patient");
        Patient storage p = allPatients[addr];
        return (p.name,p.email,p.age,p.phone,p.bloodgroup,p.dob,p.records_);
    
    }
    
    function addPatientRecord(
        string memory currentfiles,
        string memory presciptions,
        string memory finalRemarks,
        address doctor_,
        // string memory docname,
        // string memory patientName,
        address  patientaddr
        ) public payable {

        require(isPatient[patientaddr],"You are not a patient");
        require(isDoctor[msg.sender],"You are not a Doctor");
        // might have to do storage

        allPatients[patientaddr].records_.push(Record(allDoctors[doctor_].name,currentfiles,presciptions,finalRemarks,payable(doctor_),block.timestamp,msg.value,allPatients[patientaddr].name,payable(patientaddr)));
        allDoctors[doctor_].records_.push(Record(allDoctors[doctor_].name,currentfiles,presciptions,finalRemarks,payable(doctor_),block.timestamp,msg.value,allPatients[patientaddr].name,payable(patientaddr)));
        
    }
    
    function getPatientRecords(address addr) public view returns( Record[] memory records ) {
        // require(addr==msg.sender,"You are not the owner");
        require(isPatient[addr],"You are not a patient");
        if(msg.sender != addr){
            require(allPatients[addr].recordAccess[msg.sender] == true,"You are not authorized to view");
        }
        Record [] memory r = allPatients[addr].records_;
        return (r);
    }

    function getOneRecord(address addr,uint256 index) public view returns (Record memory rec) {
        Record memory r = allPatients[addr].records_[index];
        return (r);
    }

    function getRecordOfOnePatient(address p) public view returns ( Record[] memory doctorRecord ){
        Patient storage P = allPatients[p];
        uint count = 0;
        uint len = P.records_.length;
        uint pos = 0;
        require(len > 0 ,"No data");
        // if(len == 0)return ;
        for(uint i=0 ; i < P.records_.length  ;i++)
            if(P.records_[i].doctor_ == msg.sender)count+=1;
        
        Record [] memory temp = new Record[](count) ;

        for(uint i=0 ; i < P.records_.length  ;i++)
            if(P.records_[i].doctor_ == msg.sender){
               temp[pos] = P.records_[i];
               pos++;
            }
            
        return (temp);
    }
    
    function getDoctorAppointment(address docAdd)public view returns(Appointment [] memory app ){
        return (allDoctors[docAdd].appointments_);
    }

    function getPatientAppointment(address patAdd)public view returns(Appointment [] memory app ){
        return (allPatients[patAdd].myAppointments);
    }

    function updateRecordAccess (address docAddr)public {
        Patient storage P = allPatients[msg.sender];
        require(P.recordAccess[docAddr]==false,"You have already updated");
        allPatients[msg.sender].recordAccess[docAddr] = true;
    }

    // function ve

    // ADD PPPROVAL
}