class AddressModel {
  String title, address, name, phoneNum;
  AddressModel(
      {required this.address,
      required this.name,
      required this.title,
      required this.phoneNum});

  @override
  bool operator ==(other) {
    if (other is AddressModel &&
        other.address == address &&
        other.name == name &&
        other.title == title &&
        other.phoneNum == phoneNum) {
      return true;
    }
    return false;
  }

  update(AddressModel other) {
    address = other.address;
    name = other.name;
    title = other.title;
    phoneNum = other.phoneNum;
  }

  bool isEmpty() {
    return (address.isEmpty &&
        name.isEmpty &&
        title.isEmpty &&
        phoneNum.isEmpty);
  }
  //  operator =(AddressModel other) {
//  return AddressModel(address: "address", name: "name", title: "title", phoneNum: "phoneNum");
//   }
}
