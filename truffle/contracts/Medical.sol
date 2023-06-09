// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "./Medical_2.sol";
// Medical.sol
contract HealthManagement is HealthManagement2 {

    constructor(){
        patientCount = 0;
        doctorCount = 0;
        appointmentCount = 0;
        owner_ = msg.sender;
    }
    
   function addDoctor(
        string memory name,
        string memory email,
        string memory gender,
        string memory introduction,
        uint age,
        string memory location,
        address payable address_,
        uint256 basefee
        ) public  {

        require(isDoctor[msg.sender] == false,"You are already a doctor ");
        
        alldoctors.push(msg.sender);
        allDoctors[msg.sender].name = name;
        allDoctors[msg.sender].email = email;
        allDoctors[msg.sender].address_ = address_;
        allDoctors[msg.sender].introduction = introduction;
        allDoctors[msg.sender].gender = gender;
        allDoctors[msg.sender].age = age;
        allDoctors[msg.sender].location = location;
        allDoctors[msg.sender].basefee = basefee*(1 ether);
        allDoctors[msg.sender].starCount = 0;
        allDoctors[msg.sender].totalPatients = 0;
        isDoctor[msg.sender] = true;
        // allDoctors[msg.sender].records_ = Record [](0);
        doctorCount += 1;
        
   }

   function payFees(address to)public payable returns (bool sentt) {
       require(msg.value >= allDoctors[to].basefee , " Insufficient funds ");
       (bool sent, bytes memory data) = (address(payable(to))).call{value: msg.value}("");
        return sent;
        // require(sent, "Failed to send Ether");
   }
// uint256 id
   function takeAppointment(address docAddr,uint256 slot,uint256 id) public {

        Appointment memory a = Appointment(false, payable(msg.sender),payable(docAddr),allPatients[msg.sender].name , allDoctors[docAddr].name , slot,0,0,id,false);
        allDoctors[docAddr].appointments_.push(a);
        allPatients[msg.sender].myAppointments.push(a);
        // add to patients appointments too 
   }

// uint256 id
    function startAppointment(uint256 index,uint256 start) public {
        require(allDoctors[msg.sender].appointments_[index].status == false,"You have completed this appointment");
        allDoctors[msg.sender].appointments_[index].status = true;
        // allDoctors[msg.sender].appointments_[index].id = id;
        // allPatients[msg.sender].appointments_[index].id = id;
        allDoctors[msg.sender].appointments_[index].timeStart = start;
    }

    function endAppointment(uint256 index,uint256 end) public{
       require(allDoctors[msg.sender].appointments_[index].status == true,"You have not completed this appointment");
        allDoctors[msg.sender].appointments_[index].timeEnd = end;
    }
    
    function getAllDoctor() public view returns(Doctor [] memory alldocs ) {
        Doctor [] memory docs = new Doctor[](doctorCount);
        for(uint i = 0; i < doctorCount ; i++)docs[i] = allDoctors[ alldoctors[i] ];
        return docs;
    }

    function getOneDoctor(address addr) public view returns (Doctor memory doc){
        Doctor memory d = allDoctors[addr];
        return d;
    }

}