import 'package:flutter/material.dart';
import 'widgets/trip_activity_list.dart';
import 'widgets/activity_list.dart';
import 'widgets/trip_overview.dart';
import '../../data/data.dart' as data;
import '../../models/activity.model.dart';
import '../../models/trip.model.dart';

class City extends StatefulWidget {
  final List<Activity> activities = data.activities;

  City({super.key});

  showContext({required BuildContext context, required List<Widget> children}) {
    final orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.landscape) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      );
    } else {
      return Column(
        children: children,
      );
    }
  }

  @override
  State<City> createState() => _CityState();
}

class _CityState extends State<City> {
  late Trip mytrip;
  late int index;
  late List<Activity> activities;

  @override
  void initState() {
    super.initState();
    mytrip = Trip(activities: [], city: 'Paris', date: null);
    index = 0;
  }

  List<Activity> get tripActivities {
    return widget.activities
        .where((activity) => mytrip.activities.contains(activity.id))
        .toList();
  }

  void setDate() {
    showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime(2030),
    ).then((newDate) {
      if (newDate != null) {
        setState(() {
          mytrip.date = newDate;
        });
      }
    });
  }

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  void toggleActivity(String id) {
    setState(() {
      mytrip.activities.contains(id)
          ? mytrip.activities.remove(id)
          : mytrip.activities.add(id);
    });
  }

  void deleteTripActivity(String id) {
    setState(() {
      mytrip.activities.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.chevron_left),
        title: const Text('Organisation du voyage'),
        actions: const <Widget>[
          Icon(Icons.more_vert),
        ],
      ),
      body: Container(
        child: widget.showContext(
          context: context,
          children: <Widget>[
            TripOverview(
              mytrip: mytrip,
              setDate: setDate,
            ),
            Expanded(
              child: index == 0
                  ? ActivityList(
                activities: widget.activities,
                selectedActivities: mytrip.activities,
                toggleActivity: toggleActivity,
              )
                  : TripActivityList(
                activities: tripActivities,
                deleteTripActivity: deleteTripActivity,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Découverte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stars),
            label: 'Mes activités',
          )
        ],
        onTap: switchIndex,
      ),
    );
  }
}