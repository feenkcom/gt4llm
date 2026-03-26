Class {
	#name : #GtLTool,
	#superclass : #Object,
	#classVars : [
		'ShouldEnableDataViews'
	],
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLTool class >> disableDataViews [
	ShouldEnableDataViews := false
]

{ #category : #accessing }
GtLTool class >> enableDataViews [
	ShouldEnableDataViews := true
]

{ #category : #'gt - extensions' }
GtLTool class >> gtToolsFor: aView [
	<gtView>
	<gtClassView>
	^ aView columnedList
		title: 'Tools';
		items: [ ((self withAllSubclasses reject: #isAbstract)
				sort: [ :a :b | a name < b name ]) collect: #new ];
		column: 'Name' text: [ :aTool | aTool name ];
		column: 'Class' text: [ :aTool | aTool class name ]
]

{ #category : #accessing }
GtLTool class >> isAbstract [
	^ self name = #GtLTool
]

{ #category : #accessing }
GtLTool class >> serializationProperties [
	^ {#type -> #type}
]

{ #category : #accessing }
GtLTool class >> shouldEnableDataViews [
	^ShouldEnableDataViews ifNil: [ false ]
]

{ #category : #visiting }
GtLTool >> acceptVisitor: aVisitor [

	^ aVisitor visitGtLlmTool: self
]

{ #category : #'api - responses' }
GtLTool >> functionAnthropic [
	^ {'type' -> self type.
		'name' -> self name} asDictionary
]

{ #category : #'api - responses' }
GtLTool >> functionOpenAI [
	^ {'type' -> self type} asDictionary
]

{ #category : #accessing }
GtLTool >> name [
	self subclassResponsibility
]

{ #category : #accessing }
GtLTool >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPut: $(;
		nextPutAll: self type;
		nextPut: $)
]

{ #category : #accessing }
GtLTool >> type [
	^ ''
]
