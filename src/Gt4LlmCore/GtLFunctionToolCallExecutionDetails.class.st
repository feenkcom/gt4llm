Class {
	#name : #GtLFunctionToolCallExecutionDetails,
	#superclass : #Object,
	#instVars : [
		'startTime',
		'endTime'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> duration [
	self startTime ifNotNil: [ :aStartTime |
		self endTime ifNotNil: [ :anEndTime |
			^ anEndTime - aStartTime ] ].
	^ nil
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> endTime [
	^ endTime
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> endTime: aDateAndTime [
	endTime := aDateAndTime
]

{ #category : #'gt extensions' }
GtLFunctionToolCallExecutionDetails >> gtDetailsFor: aView [
	<gtView>
	<gtLlmView>
	^ aView columnedList
		title: 'Details';
		priority: 1;
		items: [ self summaryDetails ];
		column: 'Field' text: [ :each | each first ];
		column: 'Value' text: [ :each | each second printString ]
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> startTime [
	^ startTime
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> startTime: aDateAndTime [
	startTime := aDateAndTime
]

{ #category : #'gt extensions' }
GtLFunctionToolCallExecutionDetails >> summaryDetails [
	^ {
			{'Start Time'. self startTime}.
			{'End Time'. self endTime}.
			{'Duration'. self duration}
		}
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> updateEndTime [
	endTime := DateAndTime now
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> updateStartTime [
	startTime := DateAndTime now
]
