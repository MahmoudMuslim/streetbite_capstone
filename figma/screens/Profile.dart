import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
	const Profile({super.key});
	@override
	ProfileState createState() => ProfileState();
}
class ProfileState extends State<Profile> {
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
										color: Color(0xFFFFFFFF),
										width: double.infinity,
										height: double.infinity,
										child: SingleChildScrollView(
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															width: double.infinity,
															child: Row(
																mainAxisAlignment: MainAxisAlignment.spaceBetween,
																children: [
																	Container(
																		margin: const EdgeInsets.only( left: 47),
																		child: Text(
																			"9:41",
																			style: TextStyle(
																				color: Color(0xFF1C1B1F),
																				fontSize: 17,
																				fontWeight: FontWeight.bold,
																			),
																		),
																	),
																	Container(
																		width: 134,
																		height: 54,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/wop4xcxv_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 28, right: 20),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(112),
																		),
																		margin: const EdgeInsets.only( bottom: 12, left: 20),
																		width: 64,
																		height: 64,
																		child: ClipRRect(
																			borderRadius: BorderRadius.circular(112),
																			child: Image.network(
																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/lkitbqwc_expires_30_days.png",
																				fit: BoxFit.fill,
																			)
																		)
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 12, left: 20),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Text(
																						"Vlad S.",
																						style: TextStyle(
																							color: Color(0xFF1C1B1F),
																							fontSize: 36,
																							fontWeight: FontWeight.bold,
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
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/rpiu1k2m_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"Settings",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/g4kcluq0_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"Contact us",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
													IntrinsicHeight(
														child: Container(
															padding: const EdgeInsets.only( top: 12, bottom: 12, left: 16, right: 16),
															margin: const EdgeInsets.only( bottom: 377),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 24,
																		height: 24,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/oc5weqyt_expires_30_days.png",
																			fit: BoxFit.fill,
																		)
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					crossAxisAlignment: CrossAxisAlignment.start,
																					children: [
																						Text(
																							"Help center",
																							style: TextStyle(
																								color: Color(0xFF1C1B1F),
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
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.only( top: 10, bottom: 10, left: 36, right: 36),
															width: double.infinity,
															child: Row(
																children: [
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 37),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/107ymeng_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Home",
																							style: TextStyle(
																								color: Color(0xFFA09CAB),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 37),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/poxaucg9_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Browse",
																							style: TextStyle(
																								color: Color(0xFFA09CAB),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				margin: const EdgeInsets.only( right: 37),
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/mi69q75n_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Orders",
																							style: TextStyle(
																								color: Color(0xFFA09CAB),
																								fontSize: 11,
																							),
																						),
																					]
																				),
																			),
																		),
																	),
																	Expanded(
																		child: IntrinsicHeight(
																			child: Container(
																				width: double.infinity,
																				child: Column(
																					children: [
																						Container(
																							margin: const EdgeInsets.only( bottom: 3),
																							width: 24,
																							height: 24,
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/7yEiDLjdIb/t1iv2ypi_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						),
																						Text(
																							"Profile",
																							style: TextStyle(
																								color: Color(0xFF00C773),
																								fontSize: 11,
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
													IntrinsicHeight(
														child: Container(
															color: Color(0xFFFFFFFF),
															padding: const EdgeInsets.symmetric(vertical: 8),
															width: double.infinity,
															child: Column(
																children: [
																	Container(
																		decoration: BoxDecoration(
																			borderRadius: BorderRadius.circular(100),
																			color: Color(0xFF1C1B1F),
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