import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _regionController = TextEditingController();
  final _phoneController = TextEditingController();
  String _selectedRole = 'user';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _farmNameController.dispose();
    _regionController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match. Please re-enter.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authVM = context.read<AuthViewModel>();
    final success = await authVM.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole,
      farmName: _selectedRole == 'farmer' ? _farmNameController.text.trim() : null,
      region: _selectedRole == 'farmer' ? _regionController.text.trim() : null,
      contactPhone: _selectedRole == 'farmer' ? _phoneController.text.trim() : null,
    );
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Account created as ${_selectedRole == "farmer" ? "Farmer / Grower" : "Plant Enthusiast"}!'),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join MediPlant Ecosystem',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select your role to access tailored cultivation tools, plant recognition, or farmer capabilities.',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                if (authVM.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authVM.errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                Text(
                  'Choose Your Primary Role:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 10),
                Builder(
                  builder: (context) {
                    final isDark = Theme.of(context).brightness == Brightness.dark;
                    return Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'user'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'user'
                                    ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFE8F5E9))
                                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedRole == 'user'
                                      ? (isDark ? const Color(0xFF10B981) : const Color(0xFF2E7D32))
                                      : (isDark ? const Color(0xFF334155) : Colors.grey.shade300),
                                  width: _selectedRole == 'user' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    color: _selectedRole == 'user'
                                        ? (isDark ? const Color(0xFF34D399) : const Color(0xFF2E7D32))
                                        : (isDark ? Colors.grey.shade500 : Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Plant Enthusiast',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Identify plants, herbal garden, safe remedies',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedRole = 'farmer'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: _selectedRole == 'farmer'
                                    ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFE8F5E9))
                                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedRole == 'farmer'
                                      ? (isDark ? const Color(0xFF10B981) : const Color(0xFF2E7D32))
                                      : (isDark ? const Color(0xFF334155) : Colors.grey.shade300),
                                  width: _selectedRole == 'farmer' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.agriculture_rounded,
                                    color: _selectedRole == 'farmer'
                                        ? (isDark ? const Color(0xFF34D399) : const Color(0xFF2E7D32))
                                        : (isDark ? Colors.grey.shade500 : Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Farmer / Grower',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Manage crops, track harvest batches & advisory',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter your email';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password (min. 6 chars)',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.length < 6) ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please confirm your password';
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                if (_selectedRole == 'farmer') ...[
                  Builder(
                    builder: (context) {
                      final isDark = Theme.of(context).brightness == Brightness.dark;
                      final containerBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F8E9);
                      final containerBorder = isDark ? const Color(0xFF334155) : const Color(0xFFAED581);
                      final titleColor = isDark ? const Color(0xFF34D399) : const Color(0xFF1B5E20);
                      final inputFill = isDark ? const Color(0xFF0F172A) : Colors.white;
                      final inputTextColor = isDark ? Colors.white : Colors.black87;

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: containerBg,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: containerBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.nature_people_rounded, size: 18, color: titleColor),
                                const SizedBox(width: 6),
                                Text(
                                  'Grower Details (Optional)',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _farmNameController,
                              style: TextStyle(color: inputTextColor),
                              decoration: InputDecoration(
                                labelText: 'Farm / Estate Name (e.g., Green Valley)',
                                prefixIcon: const Icon(Icons.agriculture_outlined),
                                filled: true,
                                fillColor: inputFill,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _regionController,
                              style: TextStyle(color: inputTextColor),
                              decoration: InputDecoration(
                                labelText: 'Region / District (e.g., Karnataka)',
                                prefixIcon: const Icon(Icons.location_on_outlined),
                                filled: true,
                                fillColor: inputFill,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(color: inputTextColor),
                              decoration: InputDecoration(
                                labelText: 'Contact Phone Number',
                                prefixIcon: const Icon(Icons.phone_outlined),
                                filled: true,
                                fillColor: inputFill,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                ElevatedButton(
                  onPressed: authVM.isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 1,
                  ),
                  child: authVM.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          _selectedRole == 'farmer' ? 'Register as Farmer' : 'Register Account',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
