# SER502-NAAV-Team17
Code for language called "NAAV"

YouTube video link : <>

Windows OS was used to build the compiler and interpreter for our language "NAAV".

Tools used to program our language:
1. SWI-Prolog version 9.2.1 for x64-win64
2. Python 3.11.4
3. Pyswip 0.2.11
4. Ply 3.11

The "NAAV" language requires the interpreter which is replicated in the runtime.

Instructions to build the interpreter:
1. Install Python3 and SWI-Prolog
2. Clone the repository

   ```bash
   git clone https://github.com/atharva-date/SER502-NAAV-Team17.git
   ```
   
3. Open the terminal from the source directory of the project
4. Change directory from the root directory to runtime directory of the project using the following commands: 

   ```bash
    cd src
   ```
   ```bash
    cd runtime
   ```

5. Install pip packages for the interpreter to run successfully

   ```bash
   pip install git+https://github.com/yuce/pyswip@master#egg=pyswip
   ```
   ```bash
   pip install ply  
   ```

Instructions to run the interpreter:
1. Follow up on the above steps and copy entire path of the '.naav' file from data folder which needs to be executed
2. Execute the following command to get the desired output for the NAAV code
   ```bash
   python executor.py <file_path>
   ```

For example: python executor.py C:\MS_documents\ASU_Atharva_Date\Spring_2024\SER502-NAAV-Team17\data\new_data\boolean.naav
