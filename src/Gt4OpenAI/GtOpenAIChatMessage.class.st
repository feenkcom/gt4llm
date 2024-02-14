Class {
	#name : #GtOpenAIChatMessage,
	#superclass : #GtOpenAIEntity,
	#instVars : [
		'content',
		'role'
	],
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
GtOpenAIChatMessage class >> defaultRole [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
GtOpenAIChatMessage class >> from: aDictionary [
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
GtOpenAIChatMessage class >> serializationProperties [
	^ {#role -> #role.
		#content -> #content}
]

{ #category : #accessing }
GtOpenAIChatMessage >> content [
	^ content
]

{ #category : #accessing }
GtOpenAIChatMessage >> content: anObject [
	content := anObject
]

{ #category : #accessing }
GtOpenAIChatMessage >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 1;
		text: [ self content ]
]

{ #category : #accessing }
GtOpenAIChatMessage >> role [
	^ role ifNil: [ role := self class defaultRole ]
]

{ #category : #accessing }
GtOpenAIChatMessage >> role: anObject [
	role := anObject
]
