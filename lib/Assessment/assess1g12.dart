import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/Search/searchg12.dart';
import 'package:flutter/material.dart';

class QuestionG12 {
  final String questionTextG12;

  QuestionG12({
    required this.questionTextG12,
  });
}

class QuestionnaireG12 extends StatefulWidget {
  const QuestionnaireG12({Key? key}) : super(key: key);

  @override
  _QuestionnaireG12 createState() => _QuestionnaireG12();
}

class _QuestionnaireG12 extends State<QuestionnaireG12> {
  int _selectedIndex = 0; // Track the current question index
  int _totalQuestions = 75; // Default number of questions
  List<QuestionG12> _questions = []; // Store fetched questions
  List<List<String>> _options = []; // Store options for each question
  int _selectedOptionIndex = -1; // No option selected initially
  bool _isLoading = true; // Loading state for questions

  @override
  void initState() {
    super.initState();
    _fetchQuestions(); // Fetch questions from Firestore
    _fetchOptions();   // Fetch options from Firestore
  }

  Future<void> _fetchQuestions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .doc('grade12')
          .get();

      if (snapshot.exists) {
        List<QuestionG12> fetchedQuestions = [];

        _totalQuestions = snapshot.data()?.keys.length ?? 75; // Dynamically set total questions

        for (int i = 1; i <= _totalQuestions; i++) {
          String fieldName = i.toString();
          String questionText = snapshot.get(fieldName) ?? '';
          fetchedQuestions.add(QuestionG12(questionTextG12: questionText));
        }

        setState(() {
          _questions = fetchedQuestions;
          _isLoading = false;
        });
      } else {
        print('No such document!');
        setState(() {
          _isLoading = false;  // Stop loading even if document is missing
        });
      }
    } catch (e) {
      print('Error fetching questions: $e');
      setState(() {
        _isLoading = false;  // Stop loading on error
      });
    }
  }

  Future<void> _fetchOptions() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('questions')
          .doc('grade12Options')
          .get();

      if (snapshot.exists) {
        List<List<String>> fetchedOptions = [];

        for (int i = 1; i <= _totalQuestions; i++) {
          String fieldName = i.toString();
          String optionString = snapshot.get(fieldName) ?? '';
          print('Options for question $fieldName: $optionString'); // Debug statement

          List<String> optionList = optionString.split(',').map((option) => option.trim()).toList();

          while (optionList.length < 4) {
            optionList.add(''); // Fill with empty strings if there are less than 4 options
          }

          if (optionList.length > 4) {
            optionList = optionList.sublist(0, 4);
          }

          List<String> formattedOptions = [
            'A) ${optionList[0]}',
            'B) ${optionList[1]}',
            'C) ${optionList[2]}',
            'D) ${optionList[3]}',
          ];

          fetchedOptions.add(formattedOptions);
        }

        setState(() {
          _options = fetchedOptions;
        });
      } else {
        print('No such document for options!');
      }
    } catch (e) {
      print('Error fetching options: $e');
    }
  }


  void _nextQuestionG12() {
    if (_selectedIndex < _totalQuestions - 1) {
      setState(() {
        _selectedIndex++;
        _selectedOptionIndex = -1; // Reset selected option for new question
      });
    }
  }

  void _previousQuestionG12() {
    if (_selectedIndex > 0) {
      setState(() {
        _selectedIndex--;
        _selectedOptionIndex = -1; // Reset selected option for new question
      });
    }
  }

  void _selectOption(int index) {
    setState(() {
      _selectedOptionIndex = index; // Update selected option index
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final iconSize = screenWidth * 0.10;
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 158, 39, 39),
          elevation: 0,
          leading: IconButton(
            icon: Image.asset(
              'assets/back.png',
              width: 24.0,
              height: 24.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 50.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 158, 39, 39),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'IT Major in SM',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isLoading
                          ? 'Loading...'
                          : 'Question #${_selectedIndex + 1} out of $_totalQuestions',
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      _isLoading
                          ? 'Loading question...'
                          : _questions.isNotEmpty && _selectedIndex < _questions.length
                          ? _questions[_selectedIndex].questionTextG12
                          : 'No question available', // Display a message if no question is available
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              // Display options if available
              if (!_isLoading && _selectedIndex < _options.length)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 3.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _selectOption(index), // Select option on tap
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selectedOptionIndex == index
                              ? const Color.fromARGB(255, 158, 39, 39) // Selected color
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            _options[_selectedIndex][index], // Access option safely
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: _selectedOptionIndex == index
                                  ? Colors.white // White text for selected option
                                  : Colors.black, // Black text for unselected option
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                const Center(child: CircularProgressIndicator()), // Show loading indicator if options are not available
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_selectedIndex > 0)
                      ElevatedButton(
                        onPressed: _previousQuestionG12,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.grey[200]!),
                        ),
                        child: const Text(
                          'Previous',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    if (_selectedIndex < _totalQuestions - 1)
                      ElevatedButton(
                        onPressed: _nextQuestionG12,
                        child: const Text('Next'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.2,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeG12()),
                    );
                  },
                  icon: Image.asset(
                    'assets/home.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SearchG12()),
                    );
                  },
                  icon: Image.asset(
                    'assets/search.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                SizedBox(width: iconSize),
                IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/notif.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => ResultG10()),
                    // );
                  },
                  icon: Image.asset(
                    'assets/stats.png',
                    width: iconSize,
                    height: iconSize,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -iconSize * 0.75,
              left: MediaQuery.of(context).size.width / 2 - iconSize,
              child: Container(
                width: iconSize * 2,
                height: iconSize * 2,
                decoration: BoxDecoration(
                  color: Color(0xFFF08080),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 10,
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const QuestionnaireG12()),
                    );
                  },
                  icon: Image.asset(
                    'assets/main.png',
                    width: iconSize * 1.3,
                    height: iconSize * 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
