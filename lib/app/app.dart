import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdlogistic_v2/auth/UI/screens/OTP_verification.dart';
import 'package:tdlogistic_v2/auth/UI/screens/customer_login_page.dart';
import 'package:tdlogistic_v2/auth/UI/screens/home_page.dart';
import 'package:tdlogistic_v2/auth/UI/screens/shipper_login_page.dart';
import 'package:tdlogistic_v2/auth/UI/screens/splash_screen.dart';
import 'package:tdlogistic_v2/auth/bloc/auth_event.dart';
import 'package:tdlogistic_v2/auth/bloc/auth_state.dart';
import 'package:tdlogistic_v2/auth/data/models/user_model.dart';
import 'package:tdlogistic_v2/core/service/secure_storage_service.dart';
import 'package:tdlogistic_v2/core/service/socket_for_customer.dart';
import 'package:tdlogistic_v2/core/service/socket_for_shipper.dart';
import 'package:tdlogistic_v2/customer/UI/screens/botton_navigator.dart';
import 'package:tdlogistic_v2/customer/bloc/order_bloc.dart';
import 'package:tdlogistic_v2/customer/bloc/order_event.dart';
import 'package:tdlogistic_v2/core/repositories/order_repository.dart';
import 'package:tdlogistic_v2/shipper/UI/screens/botton_navigator.dart';
import 'package:tdlogistic_v2/shipper/bloc/task_bloc.dart';
import 'package:tdlogistic_v2/shipper/bloc/task_event.dart';
import 'package:tdlogistic_v2/shipper/data/models/task.dart';
import 'package:tdlogistic_v2/shipper/data/repositories/task_repository.dart';
import '../auth/bloc/auth_bloc.dart';
import '../auth/data/repositories/auth_repository.dart.dart';
import 'package:dvhcvn/dvhcvn.dart' as dvhcvn;
import 'app_bloc.dart';

class MyApp extends StatelessWidget {
  final SecureStorageService secureStorageService;
  const MyApp({
    super.key,
    required this.secureStorageService,
  });

  @override
  Widget build(BuildContext context) {
    bool hasCustomerRole(User user) {
      // Kiểm tra nếu roles không null và chứa giá trị 'CUSTOMER'
      return user.roles == null;
      //  && user.roles!.any((role) => role.value == 'CUSTOMER');
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc()..add(StartApp()),
        ),
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider<OrderBlocCus>(
          create: (context) => OrderBlocCus(
            secureStorageService: secureStorageService,
          )..add(StartOrder()),
        ),
        BlocProvider<OrderBlocSearchCus>(
          create: (context) => OrderBlocSearchCus(
            secureStorageService: secureStorageService,
          )..add(const GetOrders()),
        ),
        BlocProvider<OrderBlocFee>(
          create: (context) => OrderBlocFee(),
        ),
        BlocProvider<TaskBlocShipReceive>(
          create: (context) =>
              TaskBlocShipReceive(secureStorageService: secureStorageService),
        ),
        BlocProvider<TaskBlocShipSend>(
          create: (context) =>
              TaskBlocShipSend(secureStorageService: secureStorageService),
        ),
        BlocProvider<TaskBlocSearchShip>(
          create: (context) =>
              TaskBlocSearchShip(secureStorageService: secureStorageService),
        ),
        BlocProvider<ProcessingOrderBloc>(
          create: (context) => ProcessingOrderBloc(
            secureStorageService: secureStorageService,
          )..add(StartOrder()),
        ),
        BlocProvider<TakingOrderBloc>(
          create: (context) => TakingOrderBloc(
            secureStorageService: secureStorageService,
          )..add(StartOrder()),
        ),
        BlocProvider<DeliveringOrderBloc>(
          create: (context) => DeliveringOrderBloc(
            secureStorageService: secureStorageService,
          )..add(StartOrder()),
        ),
        BlocProvider<CancelledOrderBloc>(
          create: (context) => CancelledOrderBloc(
            secureStorageService: secureStorageService,
          )..add(StartOrder()),
        ),
        BlocProvider<PendingOrderBloc>(
          create: (context) => PendingOrderBloc(
            secureStorageService: secureStorageService,
          )..add(GetPendingTask()),
        ),
        BlocProvider<CompletedOrderBloc>(
          create: (context) => CompletedOrderBloc(
            secureStorageService: secureStorageService,
          )..add(StartOrder()),
        ),
        BlocProvider<GetImagesBloc>(
          create: (context) => GetImagesBloc(
            secureStorageService: secureStorageService,
          ),
        ),
        BlocProvider<GetImagesShipBloc>(
          create: (context) => GetImagesShipBloc(
            secureStorageService: secureStorageService,
          ),
        ),
        BlocProvider<UpdateImagesShipBloc>(
          create: (context) => UpdateImagesShipBloc(
            secureStorageService: secureStorageService,
          ),
        ),
        BlocProvider<AcceptTask>(
          create: (context) => AcceptTask(
            secureStorageService: secureStorageService,
          ),
        ),
        BlocProvider<CreateOrderBloc>(
          create: (context) => CreateOrderBloc(
            secureStorageService: secureStorageService,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              if (state.user == null) {
                return const HomePage();
              }
              if (hasCustomerRole(state.user!)) {
                connectSocket(state.token);
                return NavigatePage(user: state.user!);
              } else {
                return SocketPage(user: state.user!, token: state.token);
              }
            } else if (state is SentOtp) {
              return OtpVerificationPage(
                  email: state.email,
                  phone: state.phone,
                  msg: state.msg,
                  id: state.id);
            } else if (state is AuthFailure) {
              return state.isStaff
                  ? StaffLoginPage(
                      msg: state.error,
                      username: state.email,
                      password: state.phone)
                  : CustomerLoginPage(
                      msg: state.error, email: state.email, phone: state.phone);
            } else if (state is Unauthenticated) {
              // return SocketPage(user: User());

              return state.isStaff
                  ? const StaffLoginPage(msg: "", username: "", password: "")
                  : CustomerLoginPage(
                      msg: "", email: state.email, phone: state.phone);
            } else {
              return const SplashScreen(); // Hiển thị màn hình chờ
            }
          },
        ),
      ),
    );
  }
}
