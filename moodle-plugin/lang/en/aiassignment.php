<?php
// This file is part of Moodle - http://moodle.org/

defined('MOODLE_INTERNAL') || die();

$string['modulename'] = 'AI Assignment';
$string['modulenameplural'] = 'AI Assignments';
$string['modulename_help'] = 'The AI Assignment module allows teachers to create assignments that are automatically evaluated using artificial intelligence.';
$string['pluginname'] = 'AI Assignment';
$string['pluginadministration'] = 'AI Assignment administration';

// Capabilities
$string['aiassignment:addinstance'] = 'Add a new AI Assignment';
$string['aiassignment:view'] = 'View AI Assignment';
$string['aiassignment:submit'] = 'Submit answer';
$string['aiassignment:grade'] = 'Grade submissions';
$string['aiassignment:viewgrades'] = 'View grades';

// Form
$string['assignmentname'] = 'Assignment name';
$string['problemsettings'] = 'Problem settings';
$string['problemtype'] = 'Problem type';
$string['problemtype_help'] = 'Select the type of problem: Mathematics or Programming';
$string['math'] = 'Mathematics';
$string['programming'] = 'Programming';
$string['solution'] = 'Reference solution';
$string['solution_help'] = 'Enter the correct solution that will be used by AI to compare student answers';
$string['documentation'] = 'Additional documentation';
$string['documentation_help'] = 'Optional additional information for students';
$string['testcases'] = 'Test cases';
$string['testcases_help'] = 'Optional test cases or examples';
$string['gradesettings'] = 'Grade settings';
$string['maxattempts'] = 'Maximum attempts';
$string['maxattempts_help'] = 'Maximum number of submission attempts allowed. 0 = unlimited';

// View
$string['problemdescription'] = 'Problem description';
$string['type'] = 'Type';
$string['submitanswer'] = 'Submit your answer';
$string['submit'] = 'Submit';
$string['attemptsremaining'] = 'Attempts remaining: {$a}';
$string['maxattemptsreached'] = 'You have reached the maximum number of attempts';
$string['yoursubmissions'] = 'Your submissions';
$string['submitted'] = 'Submitted';
$string['feedback'] = 'Feedback';
$string['viewdetails'] = 'View details';
$string['pendingevaluation'] = 'Pending evaluation...';
$string['allsubmissions'] = 'All submissions';
$string['viewallsubmissions'] = 'View all submissions';
$string['nosubmission'] = 'No submission yet';

// Submission
$string['submissionsaved'] = 'Your answer has been submitted and will be evaluated automatically';
$string['submissionfailed'] = 'Failed to submit answer';
$string['answerrequired'] = 'Answer is required';
$string['answertoolong'] = 'The answer is too long (maximum {$a} characters).';

// Evaluation
$string['score'] = 'Score';
$string['aifeedback'] = 'AI Feedback';
$string['aianalysis'] = 'Detailed analysis';
$string['evaluating'] = 'Evaluating with AI...';
$string['evaluationfailed'] = 'Automatic evaluation failed';

// Settings
$string['openaiapikey'] = 'OpenAI API Key';
$string['openaiapikey_desc'] = 'Enter your OpenAI API key for automatic evaluation. Get one at https://platform.openai.com/api-keys';
$string['openaimodel'] = 'OpenAI Model';
$string['openaimodel_desc'] = 'Select the OpenAI model to use for evaluation (default: gpt-4o-mini)';
$string['demomode'] = 'Demo Mode';
$string['demomode_desc'] = 'Enable demo mode to test without OpenAI API (uses simulated evaluation)';
$string['maxresponsetime'] = 'Max Response Time';
$string['maxresponsetime_desc'] = 'Maximum time in seconds to wait for OpenAI API response (default: 30)';
$string['noapikey'] = 'OpenAI API key not configured. Please configure it in plugin settings or enable demo mode.';

// Events
$string['eventsubmissioncreated'] = 'Submission created';
$string['eventsubmissiongraded'] = 'Submission graded';
$string['eventcoursemoduleviewed'] = 'Course module viewed';

// Submissions page
$string['student'] = 'Student';
$string['attempt'] = 'Attempt';
$string['status'] = 'Status';
$string['actions'] = 'Actions';
$string['evaluated'] = 'Evaluated';
$string['pending'] = 'Pending';
$string['nosubmissions'] = 'No submissions yet';
$string['statistics'] = 'Statistics';
$string['totalsubmissions'] = 'Total submissions';
$string['averagescore'] = 'Average score';
$string['backtosubmissions'] = 'Back to submissions';

// Submission detail
$string['submissiondetails'] = 'Submission details';
$string['submissioninfo'] = 'Submission information';
$string['youranswer'] = 'Your answer';
$string['evaluation'] = 'Evaluation';
$string['reevaluate'] = 'Re-evaluate';
$string['reevaluate_help'] = 'This will re-evaluate the submission with AI. The previous grade will be replaced.';

// Index page
$string['submissions'] = 'Submissions';

// Notifications (mejora #3)
$string['notif_graded_subject']  = 'Your assignment "{$a}" has been graded';
$string['notif_graded_body']     = "Your assignment \"{$a->assignment}\" has been graded.\n\nScore: {$a->score}%\n\nFeedback: {$a->feedback}";
$string['notif_graded_small']    = 'Grade received: {$a}%';

// Character counter (mejora #6)
$string['characters']            = 'characters';

// Privacy
$string['privacy:metadata:aiassignment_submissions'] = 'Information about user submissions for AI assignments';
$string['privacy:metadata:aiassignment_submissions:userid'] = 'The ID of the user who made the submission';
$string['privacy:metadata:aiassignment_submissions:answer'] = 'The answer submitted by the user';
$string['privacy:metadata:aiassignment_submissions:status'] = 'The status of the submission (pending or evaluated)';
$string['privacy:metadata:aiassignment_submissions:score'] = 'The score received for the submission';
$string['privacy:metadata:aiassignment_submissions:feedback'] = 'Feedback provided for the submission';
$string['privacy:metadata:aiassignment_submissions:attempt'] = 'The attempt number';
$string['privacy:metadata:aiassignment_submissions:timecreated'] = 'The time when the submission was created';
$string['privacy:metadata:aiassignment_submissions:timemodified'] = 'The time when the submission was last modified';
$string['privacy:metadata:aiassignment_evaluations'] = 'Information about AI evaluations of submissions';
$string['privacy:metadata:aiassignment_evaluations:similarity_score'] = 'The similarity score calculated by AI';
$string['privacy:metadata:aiassignment_evaluations:ai_feedback'] = 'Feedback generated by AI';
$string['privacy:metadata:aiassignment_evaluations:ai_analysis'] = 'Detailed analysis generated by AI';
$string['privacy:metadata:aiassignment_evaluations:timecreated'] = 'The time when the evaluation was created';
$string['privacy:metadata:core_grades'] = 'AI Assignment stores grades in the gradebook';
$string['privacy:metadata:openai'] = 'AI Assignment sends data to OpenAI for evaluation';
$string['privacy:metadata:openai:answer'] = 'The student answer sent to OpenAI for evaluation';
$string['privacy:metadata:openai:solution'] = 'The teacher solution sent to OpenAI for comparison';

// Dashboard
$string['dashboard'] = 'Dashboard';
$string['activestudents'] = 'Active students';
$string['pendingevaluations'] = 'Pending evaluations';
$string['recentsubmissions'] = 'Recent submissions';
$string['submittedon'] = 'Submitted on';
$string['grade'] = 'Grade';
$string['view'] = 'View';
$string['gradedistribution'] = 'Grade distribution';
$string['topperformers'] = 'Top performers';
$string['nodataavailable'] = 'No data available yet';
$string['averagegrade'] = 'Average grade';
$string['totalassignments'] = 'Total assignments';
$string['assignmentsoverview'] = 'Assignments overview';
$string['assignment'] = 'Assignment';
$string['viewsubmissions'] = 'View submissions';
$string['noassignments'] = 'No AI Assignments in this course yet';


// Plagiarism detection
$string['plagiarismreport'] = 'Plagiarism Report';
$string['selectproblemforplagiarism'] = 'Select a problem to analyze for plagiarism:';
$string['analyzeplagiarism'] = 'Analyze Plagiarism';
$string['plagiarismanalysisinfo'] = 'This analysis uses AI to compare all submissions and detect potential plagiarism. It analyzes semantic, structural, and logical similarities.';
$string['analyzingplagiarism'] = 'Analyzing submissions for plagiarism... This may take a few moments.';
$string['summary'] = 'Summary';
$string['totalcomparisons'] = 'Total comparisons';
$string['suspiciouspairs'] = 'Suspicious pairs';
$string['highestsimilarity'] = 'Highest similarity';
$string['suspicioususers'] = 'Suspicious Users';
$string['suspiciousmatches'] = 'Suspicious Matches';
$string['matchedwith'] = 'Matched With';
$string['detailedcomparisons'] = 'Detailed Comparisons';
$string['similarity'] = 'Similarity';
$string['verdict'] = 'Verdict';
$string['startanalysis'] = 'Start Plagiarism Analysis';
$string['plagiarismdetectionerror'] = 'Plagiarism detection error';
$string['plagiarismdetectionfailed'] = 'Plagiarism detection failed';
$string['noproblems'] = 'No problems available';
