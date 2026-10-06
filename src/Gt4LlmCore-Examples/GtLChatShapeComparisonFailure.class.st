"
I report a mismatch between the JSON shapes of a chat's actual request history and its recorded history. I retain enough context to replace the recorded history from the debugger.
"
Class {
	#name : #GtLChatShapeComparisonFailure,
	#superclass : #Error,
	#instVars : [
		'actualMessages',
		'targetClass',
		'targetSelector',
		'comparison',
		'messageIndex',
		'chat'
	],
	#category : #'Gt4LlmCore-Examples-Model'
}

{ #category : #accessing }
GtLChatShapeComparisonFailure >> actualMessages [
	^ actualMessages
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> actualMessages: aCollection [
	actualMessages := aCollection
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> chat [
	^ chat
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> chat: aGtLChat [
	chat := aGtLChat
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> comparison [
	^ comparison
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> comparison: aGtJsonShapeComparison [
	comparison := aGtJsonShapeComparison
]

{ #category : #'gt - views' }
GtLChatShapeComparisonFailure >> gtDifferencesFor: aView [
	<gtView>
	<gtExceptionView>
	<gtEmbeddedDebuggerView>
	^ aView forward
		title: 'Shape differences';
		priority: 1;
		object: [ comparison ];
		view: #gtDifferencesFor:
]

{ #category : #'gt - debugger' }
GtLChatShapeComparisonFailure >> gtExceptionDebuggerSpecification [
	^ super gtExceptionDebuggerSpecification
		title: 'Chat history shape mismatch';
		globalDebuggingActionPragmas: #(gtLUpdateRecordedChatHistoryDebuggingAction)
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> messageIndex [
	^ messageIndex
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> messageIndex: anInteger [
	messageIndex := anInteger
]

{ #category : #printing }
GtLChatShapeComparisonFailure >> messageText [
	^ 'Recorded chat history shape differs at message {1} ({2}>>#{3})' format: {
		messageIndex.
		targetClass name.
		targetSelector }
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> targetClass [
	^ targetClass
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> targetClass: aClass [
	targetClass := aClass
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> targetSelector [
	^ targetSelector
]

{ #category : #accessing }
GtLChatShapeComparisonFailure >> targetSelector: aSymbol [
	targetSelector := aSymbol
]

{ #category : #updating }
GtLChatShapeComparisonFailure >> updateRecordedHistory [
	GtLDataSourceEncoderDecoder
		writeClientHistory: chat provider client history
		to: targetClass
		selector: targetSelector
]
