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
		text: [ self action ]
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
