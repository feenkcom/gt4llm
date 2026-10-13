"
I update recorded chat history from a GtLChatShapeComparisonFailure and then resume the failed example.
"
Class {
	#name : #GtLUpdateRecordedChatHistoryDebugAction,
	#superclass : #DebugAction,
	#category : #'Gt4LlmCore-Examples-Model'
}

{ #category : #accessing }
GtLUpdateRecordedChatHistoryDebugAction class >> defaultIcon [
	^ BrGlamorousVectorIcons save
]

{ #category : #'instance creation' }
GtLUpdateRecordedChatHistoryDebugAction class >> updateRecordedChatHistoryDebuggingActionFor: aDebugger [
	<gtLUpdateRecordedChatHistoryDebuggingAction>
	^ self forDebugger: aDebugger
]

{ #category : #accessing }
GtLUpdateRecordedChatHistoryDebugAction >> defaultLabel [
	^ 'Update recorded chat history and resume'
]

{ #category : #actions }
GtLUpdateRecordedChatHistoryDebugAction >> executeAction [
	self debugger session exception updateRecordedHistory.
	self debugger resumeAndCloseDebugger
]

{ #category : #initialization }
GtLUpdateRecordedChatHistoryDebugAction >> initialize [
	super initialize.
	self needsUpdate: false
]
