import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController(); // local part only
  final _addressController = TextEditingController();

  Map<String, dynamic>? userData;
  bool isLoading = true;

  // Country list with phone codes
  final Map<String, String> countries = {
    "India": "+91",
    "United States": "+1",
    "United Kingdom": "+44",
    "Canada": "+1",
    "Australia": "+61",
    "Germany": "+49",
    "France": "+33",
  };

  String? selectedCountry;
  String? selectedCode;

  bool isEditingUsername = false;
  bool isEditingPhone = false;
  bool isEditingAddress = false;
  bool showSaveButton = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      if (doc.exists) {
        final data = doc.data();
        setState(() {
          userData = data;

          _usernameController.text = data?['username'] ?? "";
          _addressController.text = data?['address'] ?? "";

          // Extract phone and country code
          final phone = data?['phone'];
          if (phone != null && phone.toString().isNotEmpty) {
            final code = countries.values.firstWhere(
              (c) => phone.toString().startsWith(c),
              orElse: () => "",
            );
            if (code.isNotEmpty) {
              selectedCode = code;
              selectedCountry =
                  countries.entries.firstWhere((e) => e.value == code).key;
              _phoneController.text =
                  phone.toString().substring(code.length); // local part
            } else {
              _phoneController.text = phone.toString();
            }
          }

          selectedCountry ??= "India";
          selectedCode ??= countries[selectedCountry];
        });
      }
    }
    setState(() => isLoading = false);
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final fullPhone = "${selectedCode ?? ""}${_phoneController.text.trim()}";

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({
        "username": _usernameController.text.trim(),
        "address": _addressController.text.trim(),
        "country": selectedCountry,
        "phone": fullPhone,
      });

      setState(() {
        isEditingUsername = false;
        isEditingPhone = false;
        isEditingAddress = false;
        showSaveButton = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile picture placeholder
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.person,
                          size: 60, color: Colors.white),
                    ),
                    const SizedBox(height: 20),

                    // Username
                    _buildEditableField(
                      icon: Icons.person,
                      title: "Username",
                      controller: _usernameController,
                      isEditing: isEditingUsername,
                      onEdit: () => setState(() {
                        isEditingUsername = true;
                        showSaveButton = true;
                      }),
                    ),

                    // Country
                    _buildCountryCard(),

                    // Phone
                    _buildPhoneCard(),

                    // Address
                    _buildEditableField(
                      icon: Icons.location_on,
                      title: "Address",
                      controller: _addressController,
                      isEditing: isEditingAddress,
                      onEdit: () => setState(() {
                        isEditingAddress = true;
                        showSaveButton = true;
                      }),
                    ),

                    const SizedBox(height: 30),

                    // Save button
                    if (showSaveButton)
                      ElevatedButton(
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCountryCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.flag, size: 28, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedCountry,
                isExpanded: true,
                dropdownColor: Colors.white,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
                items: countries.keys
                    .map((country) => DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCountry = value;
                    selectedCode = countries[value];
                    showSaveButton = true;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.phone, size: 28, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Text(
                  selectedCode ?? "",
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isEditingPhone
                      ? TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: UnderlineInputBorder(),
                            hintText: "Enter phone number",
                          ),
                          onChanged: (_) =>
                              setState(() => showSaveButton = true),
                        )
                      : Text(
                          _phoneController.text.isEmpty
                              ? "Not Added"
                              : _phoneController.text,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () => setState(() {
              isEditingPhone = true;
              showSaveButton = true;
            }),
          )
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.black),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                isEditing
                    ? TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: UnderlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() => showSaveButton = true),
                      )
                    : Text(
                        controller.text.isEmpty ? "Not Added" : controller.text,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: onEdit,
          )
        ],
      ),
    );
  }
}
