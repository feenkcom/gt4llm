Class {
	#name : #GtLlmActionMessage,
	#superclass : #GtLlmChatMessage,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtLlmActionMessage class >> defaultRole [
	^ nil
]

{ #category : #accessing }
GtLlmActionMessage class >> leJsonV4Name [

	^ #gtLlmActionMessage
]

{ #category : #visiting }
GtLlmActionMessage >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmActionMessage: self
]

{ #category : #'as yet unclassified' }
GtLlmActionMessage >> actionModel [
	^ (self chat assistant actionNamed: self action)
		ifNil: [ self isUserRole
				ifTrue: [ (self chat descendantOf: self)
						ifNotNil: [ :aDescendant | aDescendant actionModel ] ]
				ifFalse: [ nil ] ]
]

{ #category : #'as yet unclassified' }
GtLlmActionMessage >> contentSummary [
	^ self action
]

{ #category : #'as yet unclassified' }
GtLlmActionMessage >> gtChatRequestFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action = 'Chat' ifFalse: [ ^ aView empty ].
	self isUserRole ifFalse: [ ^ aView empty ].

	^ aView textEditor
		title: 'Message';
		priority: 1;
		text: [ self arguments first ]
]

{ #category : #'as yet unclassified' }
GtLlmActionMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #'as yet unclassified' }
GtLlmActionMessage >> gtPromoteToExampleActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat assistant actionNamed: self action.
			example := GtLlmAssistantActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
]

{ #category : #'as yet unclassified' }
GtLlmActionMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
