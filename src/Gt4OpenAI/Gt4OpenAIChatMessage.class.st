Class {
	#name : #Gt4OpenAIChatMessage,
	#superclass : #Gt4OpenAIEntity,
	#instVars : [
		'content',
		'role'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAIChatMessage class >> defaultRole [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
Gt4OpenAIChatMessage class >> from: aDictionary [
	| aRole aContent |
	aRole := aDictionary at: 'role'.
	aContent := aDictionary at: 'content'.

	self
		subclassesDo: [ :aSubclass | aSubclass defaultRole = aRole ifTrue: [ ^ aSubclass new content: aContent ] ].

	^ self new
		role: aRole;
		content: aContent
]

{ #category : #accessing }
Gt4OpenAIChatMessage class >> serializationProperties [
	^ {#role -> #role.
		#content -> #content}
]

{ #category : #accessing }
Gt4OpenAIChatMessage >> content [
	^ content
]

{ #category : #accessing }
Gt4OpenAIChatMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
Gt4OpenAIChatMessage >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ]
]

{ #category : #accessing }
Gt4OpenAIChatMessage >> role [
	^ role ifNil: [ role := self class defaultRole ]
]

{ #category : #accessing }
Gt4OpenAIChatMessage >> role: anObject [
	role := anObject
]
