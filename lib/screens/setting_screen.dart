import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../models/validations.dart';
import '../consts/constants.dart';
import '../providers/authentication/auth_other.dart';
import '../consts/enums.dart';
import '../widgets/hero_images.dart';
import '../widgets/mySnackBar.dart';
import '../widgets/mytextfield.dart';
import 'package:image_picker/image_picker.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);
  static const routeName = "settingScreen";
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var user = FirebaseAuth.instance.currentUser;
  TextEditingController fullNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController currentPassCtrl = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();
  TextEditingController rePasswordCtr = TextEditingController();
  var globalKey = GlobalKey<FormState>();
  late bool isProviderLogin;

  String? email;

  @override
  void initState() {
    fullNameCtrl.setText(user?.displayName ?? "");
    // provider login mean facebook or google , isProviderLogin be true if signin with email and password
    isProviderLogin = user!.providerData[0].providerId == "google.com" ||
        user!.providerData[0].providerId == "facebook.com";
    String email =
        isProviderLogin ? (user?.providerData[0].email)! : (user?.email)!;
    emailCtrl.setText(email);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    fullNameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtr.dispose();
    rePasswordCtr.dispose();
    currentPassCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (user?.displayName != fullNameCtrl.text) {
          await _saveAlertDialog();
        }
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: _myAppBar(),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userPicture(),
                SizedBox(height: 15),
                _person(),
                SizedBox(height: 20),
                _appSetting(),
                SizedBox(height: 10),
                _logoutBtn(context),
              ],
            ),
          ),
        )),
      ),
    );
  }

  AppBar _myAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
      title: Text(
        "Setting",
        style: TextStyle(color: Colors.black, fontSize: 22),
      ),
    );
  }

  Center _userPicture() {
    final authOther = Provider.of<AuthOther>(context, listen: false);
    return Center(
      child: Column(children: [
        Selector<AuthOther, bool>(
            selector: (context, provider) => provider.profilePicState,
            builder: (_, value, child) {
              var user2 = FirebaseAuth.instance.currentUser;
              String imgUrl = user2?.photoURL ?? "assets/images/profile.png";
              return InkWell(
                  onTap: () => Navigator.of(context)
                          .pushNamed(HeroImages.routeName, arguments: {
                        "images": [imgUrl],
                        "startIndex": 0,
                        "isProfile": true,
                        "title": user?.displayName
                      }),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[100],
                    backgroundImage: (user2?.photoURL == null
                        ? AssetImage(imgUrl)
                        : NetworkImage(imgUrl)) as ImageProvider,
                    child: value
                        ? CircularProgressIndicator(color: Colors.grey)
                        : null,
                  ));
            }),
        TextButton.icon(
            onPressed: () async {
              await _showImagePickerDialog(context, authOther)
                  .then((value) => setState(() {}));
            },
            icon: Icon(
              Icons.edit_outlined,
              color: myPrimaryColor,
              size: 20,
            ),
            label: Text(
              "Edit photo",
              style: TextStyle(color: mySecondTextColor),
            )),
      ]),
    );
  }

  Column _person() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        " Person",
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      MyTextField(
        controller: fullNameCtrl,
        labelText: "Full name",
        type: TextInputType.name,
        maxLength: 40,
      ),
      MyTextField(
        controller: emailCtrl,
        labelText: "Email",
        isEnabled: false,
      ),
      if (!isProviderLogin)
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Set the border radius to 20
                  )),
                  onPressed: () {
                    _showAlertDialog();
                  },
                  child: Text("Change password"))),
        ),
    ]);
  }

  Column _appSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          " App setting",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.language_outlined),
          title: Text("Language",
              style: TextStyle(color: myTextFieldBorderColor, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 18),
          onTap: () {},
        ),
        Divider(thickness: 2),
        ListTile(
          minVerticalPadding: 1,
          leading: Icon(Icons.contact_support_outlined),
          title: Text("Contact support",
              style: TextStyle(color: myTextFieldBorderColor, fontSize: 16)),
          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 18),
          onTap: () {},
        ),
        Divider(thickness: 2),
      ],
    );
  }

  TextButton _logoutBtn(BuildContext context) {
    return TextButton.icon(
        onPressed: () async {
          if (await _logoutAlertDialog()) {
            context.read<AuthOther>().logOut(context);
          }
        },
        icon: Icon(
          Icons.logout_outlined,
          color: myPrimaryColor,
          size: 25,
        ),
        label: Text(
          "Logout",
          style: TextStyle(color: myPrimaryColor, fontSize: 18),
        ));
  }

  _showAlertDialog() {
    String currentPassError = "";
    String passError = "";
    String repassError = "";
    showDialog(
        context: context,
        builder: (context) {
          bool loading = false;
          return AlertDialog(
            title: Text('Change password'),
            content: SizedBox(
              height: 200,
              child: SingleChildScrollView(
                child: StatefulBuilder(
                  builder: (context, setState) => Form(
                      key: globalKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextField(
                              labelText: "Current Password",
                              type: TextInputType.text,
                              controller: currentPassCtrl,
                              validator: (value) {
                                setState(() {
                                  currentPassError =
                                      Validations.validatePasswrd(
                                          password: value);
                                });
                              },
                            ),
                            if (currentPassError != "")
                              _errorText(currentPassError),
                            MyTextField(
                              labelText: "New Password",
                              type: TextInputType.text,
                              controller: passwordCtr,
                              validator: (value) {
                                setState(() {
                                  passError = Validations.validatePasswrd(
                                      password: value);
                                });
                              },
                            ),
                            if (passError != "") _errorText(passError),
                            MyTextField(
                              labelText: "Repeat Password",
                              type: TextInputType.text,
                              controller: rePasswordCtr,
                              validator: (value) {
                                if (!Validations.validateRepassword(
                                    repassword: value,
                                    password: passwordCtr.value.text)) {
                                  setState(
                                      () => repassError = "Dissmatch password");
                                }
                              },
                            ),
                            if (repassError != "") _errorText(repassError),
                          ])),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              StatefulBuilder(builder: (context, saveSetState) {
                return TextButton(
                  onPressed: () {
                    saveSetState(() => loading = true);
                    setState(() {
                      currentPassError = "";
                      passError = "";
                      repassError = "";
                      globalKey.currentState?.validate();
                    });
                    if (currentPassError == "" &&
                        passError == "" &&
                        repassError == "") {
                      AuthOther()
                          .changePassword(
                              currentPass: currentPassCtrl.text,
                              newPassword: passwordCtr.text)
                          .then((value) {
                        saveSetState(() => loading = false);
                        if (value) {
                          MySnackbar.showSnackBar(
                              context,
                              "Done!, the password changed.",
                              SnackBarType.success);
                          Navigator.of(context).maybePop(true);
                        } else {
                          MySnackbar.showSnackBar(context,
                              "Some thing wrong, try again", SnackBarType.fail);
                        }
                      });
                    } else {
                      saveSetState(() => loading = false);
                    }
                  },
                  child: loading
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator())
                      : Text('Save'),
                );
              })
            ],
          );
        });
  }

  Future<void> _saveAlertDialog() {
    bool saveLoading = false;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notice"),
        content: Text("Did you want to save changes?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          StatefulBuilder(
            builder: (context, saveDialogState) {
              return TextButton(
                  onPressed: () async {
                    saveDialogState(() => saveLoading = true);
                    await user!
                        .updateDisplayName(fullNameCtrl.text)
                        .then((value) {
                      saveDialogState(() => saveLoading = false);
                      MySnackbar.showSnackBar(
                          context, "Done!", SnackBarType.success);
                      Navigator.pop(context);
                    });
                  },
                  child: saveLoading
                      ? SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator())
                      : Text("Save"));
            },
          )
        ],
      ),
    );
  }

  Future _logoutAlertDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notice"),
        content: Text("Did you want to logout?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("logout"))
        ],
      ),
    );
  }

  Future<void> _showImagePickerDialog(BuildContext cxt, authOther) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Take a picture'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Select from gallery'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        // ignore: use_build_context_synchronously
        await authOther.changeProfileImage(cxt, pickedFile);
      }
    }
  }
}

Widget _errorText(String errorText) {
  return Padding(
    padding: EdgeInsets.only(left: 20, bottom: 3),
    child: Text(
      errorText,
      textAlign: TextAlign.left,
      style: TextStyle(color: myPrimaryColor, fontSize: 12),
    ),
  );
}
