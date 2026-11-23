"
I am an abstract type of variable declared by a class: an instance slot, a class slot or a class variable. I know how to read the names of my type from a {{gtClass:GtLClassDefinitionDescription}}. All instances of one concrete subclass are equal; use `GtLVariableType all` to get the unique instances.
"
Class {
	#name : #GtLVariableType,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLVariableType class >> all [
	^ {GtLInstanceSlotType uniqueInstance.
		GtLClassSlotType uniqueInstance.
		GtLClassVariableType uniqueInstance}
]

{ #category : #comparing }
GtLVariableType >> = anObject [
	^ self class = anObject class
]

{ #category : #accessing }
GtLVariableType >> declaredNamesIn: aClassDefinitionDescription [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLVariableType >> descriptionFor: aVariableName [
	^ self label , ' ' , aVariableName asString
]

{ #category : #comparing }
GtLVariableType >> hash [
	^ self class hash
]

{ #category : #accessing }
GtLVariableType >> label [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLVariableType >> namesIn: aClassDefinitionDescription [
	^ (self declaredNamesIn: aClassDefinitionDescription)
		collect: [ :each | each asString ]
]

{ #category : #printing }
GtLVariableType >> printOn: aStream [
	aStream nextPutAll: self label
]
