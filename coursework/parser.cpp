#include <fstream>
#include <iostream>
#include <string>
#include <vector>
#include <cstdlib>

typedef struct fammember {
    std::string name;
    int id;
    int sex;
} FamMember;

int getId(const std::string &str, int pos);
int getSex(const std::string &str);
void getName(const std::string &str, std::string &name);
int FindIndex(const std::vector<FamMember> family, int id);


int main() {
    std::ifstream fin("/Users/linuxoid/Desktop/LP/tree.ged");
    std::ofstream fout("/Users/linuxoid/Desktop/LP/gen.pl");
    std::vector<FamMember> family;
    std::string str;
    FamMember tmp;
    
    
    if (fin.is_open()) {
        while (std::getline(fin, str)) {
            if (str[0] == '0' && str[3] == 'I')
                break;
        }
        do {
            if (str[0] == '0') {
                if (str[3] == 'I') {
                    tmp.id = getId(str, 4);
                }
                else { break; }
            }
            else if (str[0] == '1') {
                if (str.substr(2, 3) == "SEX"){
                    tmp.sex = getSex(str);
                    family.push_back(tmp);
                    tmp.name.clear();
                }
                else if (str.substr(2, 4) == "NAME") {
                    getName(str, tmp.name);
                }
            }
        } while (std::getline(fin, str));
        
        int husb_id = -1;
        int wife_id = -1;
        std::vector<int> children;
        while(std::getline(fin, str)) {
            if (str[0] == '1') {
                std::string substr = str.substr(2, 4);
                if (substr == "HUSB") {
                    husb_id = getId(str, 9);
                }
                else if (substr == "WIFE") {
                    wife_id = getId(str, 9);
                }
                else if (substr == "CHIL") {
                    children.push_back(getId(str, 9));
                }
            }
            else if (str[0] == '0') {
                for (int j = 0; j < children.size(); ++j) {
                    if ((husb_id != -1) && (wife_id != -1)) {
                        int ind_h = FindIndex(family, husb_id);
                        int ind_w = FindIndex(family, wife_id);
                        int child = FindIndex(family, children[j]);
                        fout << "parent(\"";
                        fout << family[ind_h].name << "\", \"";
                        fout << family[child].name << "\").\n";
                        fout << "parent(\"";
                        fout << family[ind_w].name << "\", \"";
                        fout << family[child].name << "\").\n";
                    }
                }
                children.clear();
            }
        }
        for (int i = 0; i < family.size(); i++) {
            if (family[i].sex == 2)
                fout << "sex(\"" << family[i].name << "\", \"male\").\n";
            else if (persons[i].sex == 3)
                fout << "sex(\"" << family[i].name << "\", \"female\").\n";
            else
                fout << "sex(\"" << family[i].name << "\", \"none\").\n";
        }
        fin.close();
        fout.close();
        return 0;
    }
    else {
        std::cout << "Cannot open the file\n";
        return 0;
    }
}

int getSex(const std::string &str) {
    if (str[6] == 'M')
        return 2;
    else {
        if (str[6] == 'F')
            return 3;
        else return 0;
    }
}

int getId(const std::string &str, int pos) {
    char ch[50];
    int i;
    for (i = pos; str[i] != '@'; ++i)
        ch[i - pos] = str[i];
    ch[i] = '\0';
    return atoi(ch);
}


void getName(const std::string &str, std::string &name) {
    int i;
    for (i = 7; str[i] != '/'; ++i) {
        if (str[i] != '"')
            name.push_back(str[i]);
    }
    for (i++ ; str[i] != '/'; ++i) {
        if (str[i] != '"')
            name.push_back(str[i]);
    }
}

int FindIndex(const std::vector<FamMember> family, int id) {
    for (int i = 0; i < family.size(); ++i)
        if (family[i].id == id)
            return i;
    return 0;
}
