import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import '../dto/request/user_update_request.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  var _txtPhone = TextEditingController();
  var _txtBirthday = TextEditingController();
  var _txtEmail = TextEditingController();
  var _txtFullname = TextEditingController();
  var user = null;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.currentUser!;
    _txtFullname.text = user.fullName!;
    _txtPhone.text = user.phone!;
    _txtEmail.text = user.email!;
    _txtBirthday.text = DateFormat('yyyy-MM-dd').format(user.dob!);
    print(user);
    //  WidgetsBinding.instance.addPostFrameCallback((_) {
    //    final userProvider = Provider.of<UserProvider>(context, listen: false);

    //   });
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: AppBar(
          flexibleSpace: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.jpg'),
                      fit: BoxFit.cover,
                      // opacity: 0.6,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: 90),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: (user.avatar?.isNotEmpty ?? false)
                        ? NetworkImage(
                            'http://localhost:8080/api/files/download/image/${userProvider.currentUser!.avatar}')
                        : null,
                    child: (user.avatar?.isEmpty ?? true)
                        ? const Icon(Icons.person, size: 40)
                        : null,

                    // backgroundImage: NetworkImage(userProvider
                    //     .currentUser!.avatar!), // Update image URL dynamically
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Personal Information",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     padding: EdgeInsets.only(bottom: 40),
              //     child: ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           backgroundColor: Color(0xFFF2F2F2)),
              //       onPressed: () => {},
              //       child: Text(
              //         "Change avatar",
              //         style: TextStyle(
              //           // color: Colors.black54,
              //           fontSize: 16,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: Consumer<UserProvider>(builder: (context, userProvider, child) {
        // if (userProvider.isLoading) {
        //   return Center(
        //       child: CircularProgressIndicator()); // Show loading spinner
        // }

        if (userProvider.currentUser == null) {
          return Center(child: Text('User not found or failed to load.'));
        }

        // Fill in text controllers with the user data

        // _txtFullname.text = currentUser.fullName!;
        // _txtPhone.text = currentUser.phone!;
        // _txtEmail.text = currentUser.email!;
        // _txtBirthday.text = DateFormat('yyyy-MM-dd').format(currentUser.dob!);

        return Container(
          color: const Color.fromARGB(255, 0, 0, 0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('About you'),
                SizedBox(height: 8),
                _renderAboutField(user, context),
                SizedBox(height: 24),
                _buildSectionTitle('Account Information'),
                SizedBox(height: 8),
                _renderInfoField(user, context),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _renderAboutField(User currentUser, BuildContext context) {
    return Card(
      color: Color(0xFFF2F2F2),
      child: Column(
        children: [
          _buildInfoRow('fullName', _txtFullname.text, _txtFullname, context),
          // _buildInfoTextbox('Bio', _txtBio.text, _txtBio, context),
          _buildInfoRow('dob', _txtBirthday.text, _txtBirthday, context),
        ],
      ),
    );
  }

  Widget _renderInfoField(User currentUser, BuildContext context) {
    return Card(
      color: Color(0xFFF2F2F2),
      child: Column(
        children: [
          _buildInfoRow('phone', _txtPhone.text, _txtPhone, context),
          _buildInfoRow('email', _txtEmail.text, _txtEmail, context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ));
  }

  Widget _buildInfoRow(String label, String value, TextEditingController txt,
      BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(
                value,
                // style: TextStyle(color: Colors.black54),
              ),
              IconButton(
                onPressed: () => _showEditDialog(label, txt, context),
                icon: Icon(Icons.arrow_forward),
                color: Colors.blue,
              )
            ],
          )
        ]));
  }

  void _showEditDialog(
      String label, TextEditingController controller, BuildContext context) {
    showDialog(
      context: context,
      builder: (ct) {
        return SizedBox(
          height: 200,
          child: AlertDialog(
            title: Text(
              'Edit Info',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  label == 'dob'
                      ? _buildEditableDatePickerRow(controller, context)
                      : _buildEditableRow(
                          label, controller, 1), // TextField for other fields
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(50, 40),
                        backgroundColor: Colors.black,
                      ),
                      onPressed: () => _saveInfo(label, controller, context),
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom method to display the DatePicker for DOB
  Widget _buildEditableDatePickerRow(
      TextEditingController controller, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Birthday: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              // Show the date picker
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: controller.text.isNotEmpty
                    ? DateFormat('yyyy-MM-dd').parse(controller.text)
                    : DateTime
                        .now(), // Default to today's date if no value exists
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (selectedDate != null) {
                // Format the selected date to match the format
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                controller.text =
                    formattedDate; // Update the controller with the selected date
              }
            },
            child: AbsorbPointer(
              // Prevent user from typing directly
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Select date of birth',
                  border: InputBorder.none,
                ),
                readOnly:
                    true, // Make the TextField read-only since we're using DatePicker
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Default editable row for other fields
  Widget _buildEditableRow(
      String label, TextEditingController controller, int maxLines) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownRow(
      String label, List<String> options, String initialValue) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label:', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: initialValue,
              items: options
                  .map((option) =>
                      DropdownMenuItem(value: option, child: Text(option)))
                  .toList(),
              onChanged: (value) {
                // Handle gender selection
              },
            ),
          ],
        ));
  }

  void _saveInfo(String attribute, TextEditingController controller,
      BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Create UpdateUserWithAttribute with the selected attribute and its value
    UpdateUserWithAttribute userInfo = UpdateUserWithAttribute(
        id: userProvider.currentUser!.id!,
        attribute: attribute,
        value: controller.text);

    // Call the provider method to update the user info
    userProvider.editUserInfoByPart(userInfo, context);

    Navigator.pop(context); // Close the dialog after saving
  }
}
