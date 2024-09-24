Class {
	#name : #GtOpenAIActionThreadMessage,
	#superclass : #GtOpenAIThreadMessage,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIActionThreadMessage >> action [
	^ self contentJson at: 'Action' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> actionName [
	^ self contentJson at: 'Action' ifAbsent: [ '' ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> contentJson [
	self contentText ifEmpty: [ ^ {} asDictionary ].
	^ STONJSON fromString: self contentText
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> contentSummary [
	^ self action
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtActionFor: aView [
	<gtView>
	<gtLlmMessageView>
	self action isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Action';
		priority: 3;
		text: [ self action ];
		actionButtonLabel: 'Action' action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtContentFor: aView [
	<gtView>
	<gtLlmMessageView>
	^ aView empty
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtInspectActionFor: anAction [
	<gtLlmAction>
	(self chat tutor actionNamed: self actionName) ifNil: [ ^ anAction noAction ].

	^ anAction button
		priority: 1;
		icon: BrGlamorousVectorIcons inspect;
		label: 'Action';
		action: [ :aButton | aButton phlow spawnObject: (self chat tutor actionNamed: self action) ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtInspectorContentFor: aView [
	<gtView>
	^ aView explicit
		title: 'Content';
		priority: 5;
		stencil: [ GtLlmThreadMessageElement new threadMessageViewModel: self asViewModel ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtPromoteToExampleActionFor: anAction [
	<gtLlmAction>
	self isAssistantRole ifFalse: [ ^ anAction noAction ].

	^ anAction dropdown
		priority: 5;
		label: 'Promote example';
		content: [ :aButton | 
			| action example |
			action := self chat tutor actionNamed: self action.
			example := GtLlmTutorActionExample new
					input: self ancestor contentJson;
					output: self contentJson.
			action addExample: example.
			action persist.
			example asGtMagritteViewModel asElement ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtReifyMessageActionFor: anAction [
	<gtLlmAction>
	^ anAction button
		priority: 1;
		label: 'Reify';
		action: [ :aButton | 
			| newTutor newChat newMessages |
			newTutor := self chat tutor class newSubclass.
			newChat := self chat class newSubclass.
			newMessages := self class newSubclass.
			newTutor
				compile: 'chatClass
	^ ' , newChat name.
	
			newChat
				compile: 'messageClass
	^ ' , newMessages name.

			newTutor adoptInstance: self chat tutor.
			newChat adoptInstance: self chat.


			aButton phlow spawnObject: self chat ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> gtTextFor: aView [
	<gtView>
	<gtLlmMessageView>
	self textBlock isEmptyOrNil ifTrue: [ ^ aView empty ].

	^ aView textEditor
		title: 'Text';
		priority: 2;
		text: [ self textBlock ]
]

{ #category : #accessing }
GtOpenAIActionThreadMessage >> textBlock [
	^ self contentJson at: 'Text' ifAbsent: [ '' ]
]
