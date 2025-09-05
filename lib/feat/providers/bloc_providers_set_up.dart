import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/feat/data/repository/auth/i_user_repositiory.dart';
import 'package:percon_app/feat/data/repository/auth/user_repository.dart';
import 'package:percon_app/feat/data/repository/travel/travel_repository.dart';
import 'package:percon_app/feat/data/service/auth/google_sign_in_service.dart';
import 'package:percon_app/feat/data/service/travel/travel_service.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/home/travel_cubit.dart';
import 'package:percon_app/feat/presentation/cubit/profile/profile_cubit.dart';
import 'package:provider/single_child_widget.dart';

class BlocProvidersSetUp {
  static List<SingleChildWidget> providers = [
    RepositoryProvider<IUserRepositiory>(
      create: (context) => UserRepository(
        googleSignInService: GoogleSignInService(),
        firestore: FirebaseFirestore.instance,
      ),
    ),
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(
        userRepository: UserRepository(
          googleSignInService: GoogleSignInService(),
          firestore: FirebaseFirestore.instance,
        ),
      ),
    ),
    BlocProvider<TravelCubit>(
      create: (context) => TravelCubit(
        travelRepository: TravelRepository(travelService: TravelService()),
      ),
    ),
    BlocProvider<ProfileCubit>(
      create: (context) =>
          ProfileCubit(userRepository: context.read<IUserRepositiory>()),
    ),
  ];
}
