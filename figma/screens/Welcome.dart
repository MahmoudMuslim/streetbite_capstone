import 'package:flutter/material.dart';
class Welcome extends StatefulWidget {
	const Welcome({super.key});
	@override
	WelcomeState createState() => WelcomeState();
}
class WelcomeState extends State<Welcome> {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: SafeArea(
				child: Container(
					constraints: const BoxConstraints.expand(),
					color: Color(0xFFFFFFFF),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							Expanded(
								child: IntrinsicHeight(
									child: Container(
										color: Color(0xFF00C773),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( bottom: 366),
															width: double.infinity,
															decoration: BoxDecoration(
																image: DecorationImage(
																	image: NetworkImage("https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/nj47yvw3_expires_30_days.png"),
																	fit: BoxFit.fill
																),
															),
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Container(
																						margin: const EdgeInsets.only( left: 47),
																						child: Text(
																							"9:41",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
																								fontSize: 17,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					Container(
																						width: 134,
																						height: 54,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/uwi8h2vz_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 69),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( top: 36),
																			margin: const EdgeInsets.only( bottom: 32),
																			width: double.infinity,
																			child: Column(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 12, left: 33, right: 33),
																						width: double.infinity,
																						child: Text(
																							"Food and groceries delivered to you",
																							style: TextStyle(
																								color: Color(0xFFFFFFFF),
																								fontSize: 36,
																								fontWeight: FontWeight.bold,
																							),
																							textAlign: TextAlign.center,
																						),
																					),
																					Container(
																						width: 215,
																						child: Text(
																							"Enter your phone number to get started",
																							style: TextStyle(
																								color: Color(0xFFF7F7F7),
																								fontSize: 16,
																							),
																							textAlign: TextAlign.center,
																						),
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								borderRadius: BorderRadius.circular(12),
																								color: Color(0xFFE5F9F1),
																							),
																							padding: const EdgeInsets.symmetric(vertical: 12),
																							margin: const EdgeInsets.only( bottom: 16, left: 24, right: 24),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( left: 16, right: 23),
																										child: Text(
																											"+1",
																											style: TextStyle(
																												color: Color(0xFFA09CAB),
																												fontSize: 16,
																											),
																										),
																									),
																									Text(
																										"(555) 555-1234",
																										style: TextStyle(
																											color: Color(0xFFA09CAB),
																											fontSize: 16,
																										),
																									),
																								]
																							),
																						),
																					),
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(28),
																									color: Color(0xFFE5F9F1),
																								),
																								padding: const EdgeInsets.symmetric(vertical: 14),
																								margin: const EdgeInsets.symmetric(horizontal: 24),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Continue",
																											style: TextStyle(
																												color: Color(0xFF00C773),
																												fontSize: 16,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.symmetric(vertical: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(100),
																			color: Color(0xFFFFFFFF),
																		),
																		width: 139,
																		height: 5,
																		child: SizedBox(),
																	),
																]
															),
														),
													),
												],
											)
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}