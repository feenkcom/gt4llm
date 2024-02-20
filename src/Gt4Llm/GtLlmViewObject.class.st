Class {
	#name : #GtLlmViewObject,
	#superclass : #Object,
	#instVars : [
		'instance',
		'view',
		'threadMessage'
	],
	#category : #'Gt4Llm-Stylers'
}

{ #category : #accessing }
GtLlmViewObject >> createErrorString: anError [
	^ 'Encountered an error in the view: ' , anError messageText
		, '
Trace:
' , (self createStackString: anError)
]

{ #category : #accessing }
GtLlmViewObject >> createStackString: anError [
	(anError isKindOf: SyntaxErrorNotification)
		ifTrue: [ ^ 'Syntax Error: ' , anError messageText ].

	^ String
		streamContents: [ :stream | 
			anError signalContext stack
				do: [ :stackItem | 
					stream
						print: stackItem;
						cr ] ]
]

{ #category : #accessing }
GtLlmViewObject >> gtViewFor: aView [
	<gtView>
	[ ^ self instance perform: self view selector withArguments: {aView} ]
		on: Error
		do: [ :anError | 
			^ aView textEditor
				title: 'View error';
				priority: 1;
				text: [ anError asString ];
				actionButtonIcon: BrGlamorousVectorIcons play
					tooltip: 'Send to chat'
					action: [ self threadMessage chat
							sendMessage: (GtLlmCheckerError new
									checker: self;
									content: anError;
									contentString: (self createErrorString: anError)) asString ] ]
]

{ #category : #accessing }
GtLlmViewObject >> instance [
	^ instance
]

{ #category : #accessing }
GtLlmViewObject >> instance: anObject [
	instance := anObject
]

{ #category : #accessing }
GtLlmViewObject >> threadMessage [
	^ threadMessage
]

{ #category : #accessing }
GtLlmViewObject >> threadMessage: anObject [
	threadMessage := anObject
]

{ #category : #accessing }
GtLlmViewObject >> view [
	^ view
]

{ #category : #accessing }
GtLlmViewObject >> view: anObject [
	view := anObject
]
