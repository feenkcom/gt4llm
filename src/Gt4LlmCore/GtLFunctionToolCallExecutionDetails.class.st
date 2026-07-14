Class {
	#name : #GtLFunctionToolCallExecutionDetails,
	#superclass : #Object,
	#instVars : [
		'startTime',
		'endTime',
		'telemetryPing'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> durationWithGc [
	self startTime ifNotNil: [ :aStartTime |
		self endTime ifNotNil: [ :anEndTime |
			^ anEndTime - aStartTime ] ].
	^ nil
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> durationWithoutGc [
	^ self durationWithGc 
		ifNil: [ nil ] 
		ifNotNil: [ :aTotalDuration |
			self gcDuration 
				ifNil: [ nil ] 
				ifNotNil: [ :aGcDuration |
					aTotalDuration - aGcDuration] ]
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> endTime [
	^ endTime
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> endTime: aDateAndTime [
	endTime := aDateAndTime
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> finishTelemetryPing [
	| currentEndTime |
	currentEndTime := Time microsecondClockValue.

	telemetryPing
		realEndTime: Time microsecondClockValue;
		endTime: currentEndTime;
		recordOverheadEndTime
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> gcDuration [
	telemetryPing ifNil: [ ^ nil ].
	
	telemetryPing gcEndTime ifNotNil: [ :anEndTime | 
			telemetryPing gcStartTime ifNotNil: [ :aStartTime |
				^ Duration microSeconds: anEndTime - aStartTime ] ].
	^ nil 
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

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> startTelemetryPing [
	| realStart gcTime |
	realStart := Time microsecondClockValue.
	gcTime := Smalltalk vm totalGCTime.
	
	telemetryPing := TelemetryPing new.
	telemetryPing name: 'LLM Function call'.
	
	telemetryPing realStartTime: realStart.
	telemetryPing recordOverheadStartTime.
	telemetryPing startTime: Time microsecondClockValue.
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
			{'Total Duration'. self totalDuration}.
			{'GC Duration'. self gcDuration}
		}
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> telemetryPing: aTelemetryPing [
	telemetryPing := aTelemetryPing
]

{ #category : #accessing }
GtLFunctionToolCallExecutionDetails >> totalDuration [
	^ self durationWithGc
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> updateEndTime [
	endTime := DateAndTime now
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> updateExecutionStarted [
	self updateStartTime.
	self startTelemetryPing.
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> updateExecutionTerminated [
	self updateEndTime.
	self finishTelemetryPing.
]

{ #category : #updating }
GtLFunctionToolCallExecutionDetails >> updateStartTime [
	startTime := DateAndTime now
]
