# Figma to Flutter - Example Walkthrough

## Real-World Example: Login Screen

### Step 1: Design in Figma

```
Login Screen (FRAME - 375x812)
├── Background (RECTANGLE - white)
├── Logo (VECTOR - 80x80)
├── Welcome Text (TEXT - "Welcome Back")
├── Email Input Container (RECTANGLE - 335x56)
│   └── Email Placeholder (TEXT - "Email")
├── Password Input Container (RECTANGLE - 335x56)
│   └── Password Placeholder (TEXT - "Password")
├── Login Button (RECTANGLE - 335x56, blue)
│   └── Button Text (TEXT - "Login")
└── Forgot Password Link (TEXT - "Forgot Password?")
```

### Step 2: Get Figma URL
```
https://www.figma.com/file/AbCdEf123456/LoginScreenDesign
```

### Step 3: Run Flyer Command
```bash
# Set token (first time only)
export FIGMA_TOKEN="figd_your_token_here"

# Convert to Flutter
flyer figma --url https://www.figma.com/file/AbCdEf123456/LoginScreenDesign \
            --output lib/screens/login_screen.dart
```

### Step 4: Generated Output

```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 812,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
      ),
      child: Stack(
        children: [
          // Logo
          Positioned(
            left: 147.5,
            top: 120,
            child: Icon(
              Icons.help_outline, // Replace with actual logo
              size: 80,
            ),
          ),

          // Welcome Text
          Positioned(
            left: 20,
            top: 240,
            child: Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            ),
          ),

          // Email Input
          Positioned(
            left: 20,
            top: 320,
            child: Container(
              width: 335,
              height: 56,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // Password Input
          Positioned(
            left: 20,
            top: 396,
            child: Container(
              width: 335,
              height: 56,
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // Login Button
          Positioned(
            left: 20,
            top: 492,
            child: Container(
              width: 335,
              height: 56,
              decoration: BoxDecoration(
                color: Color(0xFF3380FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Forgot Password
          Positioned(
            left: 125,
            top: 568,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF3380FF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### Step 5: Improve Generated Code

Now let's make it production-ready:

```dart
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 120),

                // Logo - Replace Icon with actual asset
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 80,
                    height: 80,
                  ),
                ),

                const SizedBox(height: 40),

                // Welcome Text
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),

                const SizedBox(height: 40),

                // Email Input - Converted from Container to TextFormField
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Password Input
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Login Button - Converted to ElevatedButton
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3380FF),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Forgot Password - Converted to TextButton
                Center(
                  child: TextButton(
                    onPressed: _handleForgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF3380FF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      // Add your login logic here
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  void _handleForgotPassword() {
    // Navigate to forgot password screen
    print('Navigate to forgot password');
  }
}
```

## Comparison: Before vs After

### Generated Code
- ✓ Layout structure
- ✓ Colors and styling
- ✓ Text content
- ✓ Dimensions
- ✗ No functionality
- ✗ Static Stack layout
- ✗ No form validation

### Production Code
- ✓ Same visual design
- ✓ Proper widgets (TextFormField, ElevatedButton)
- ✓ Form validation
- ✓ State management
- ✓ Responsive (Column instead of Stack)
- ✓ Event handlers
- ✓ SafeArea and ScrollView

## Time Saved

**Without Flyer:**
- Design analysis: 15 min
- Manual coding: 45 min
- **Total: 60 minutes**

**With Flyer:**
- Code generation: 2 min
- Refactoring: 15 min
- **Total: 17 minutes**

**⏱️ Time saved: 43 minutes (72%)**

## Next Steps

1. Add assets (logo image)
2. Implement authentication logic
3. Add loading states
4. Add error handling
5. Connect to backend API
6. Add navigation
7. Add animations (optional)

## Tips for Better Results

### In Figma:
1. Name layers clearly: "Email Input" not "Rectangle 45"
2. Group related elements
3. Use consistent spacing
4. Apply text styles
5. Use color styles

### In Generated Code:
1. Replace Stack with Column/Row when possible
2. Convert Containers to proper widgets (TextFormField, etc.)
3. Add state management
4. Add validation and error handling
5. Make responsive using MediaQuery
6. Extract reusable widgets

## Common Improvements Needed

### 1. Replace Stack with Column
```dart
// Generated (Stack)
Stack(
  children: [
    Positioned(top: 100, child: Widget1()),
    Positioned(top: 200, child: Widget2()),
  ],
)

// Improved (Column)
Column(
  children: [
    Widget1(),
    SizedBox(height: 100),
    Widget2(),
  ],
)
```

### 2. Convert to Interactive Widgets
```dart
// Generated (Container)
Container(
  decoration: BoxDecoration(color: Colors.blue),
  child: Text('Login'),
)

// Improved (ElevatedButton)
ElevatedButton(
  onPressed: _handleLogin,
  child: Text('Login'),
)
```

### 3. Make Responsive
```dart
// Generated (Fixed width)
Container(width: 335, height: 56)

// Improved (Responsive)
Container(
  width: MediaQuery.of(context).size.width - 40,
  height: 56,
)
// Or better:
SizedBox(
  width: double.infinity,
  height: 56,
)
```

## Conclusion

Flyer's Figma conversion is a **starting point**, not a final product. Use it to:
- ✓ Save time on layout structure
- ✓ Get accurate colors and spacing
- ✓ Bootstrap your UI quickly

Then improve by:
- ✓ Adding proper widgets
- ✓ Making responsive
- ✓ Adding functionality
- ✓ Following Flutter best practices
