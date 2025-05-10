import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalfan_center/bloc/auth/auth_bloc.dart';
import 'package:khalfan_center/config/themes.dart';
import 'package:khalfan_center/widgets/logo.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );
    
    _animationController.forward();
    
    // Check authentication status after a delay
    Future.delayed(Duration(seconds: 3), () {
      context.read<AuthBloc>().add(CheckAuthStatusEvent());
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Center(
            child: Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Logo(size: 180),
                    SizedBox(height: 32),
                    Text(
                      'مركز خلفان لتحفيظ القرآن الكريم',
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Khalfan Quran Memorization Center',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 80),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
