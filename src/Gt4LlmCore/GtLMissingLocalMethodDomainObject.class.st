"
I am an abstract error result for a method reference whose class does not define the method itself. #definingMethodReference names the method that defines the source and can be used in a new request.
"
Class {
	#name : #GtLMissingLocalMethodDomainObject,
	#superclass : #GtLMissingDomainObject,
	#instVars : [
		'definingMethodReference'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'instance creation' }
GtLMissingLocalMethodDomainObject class >> methodReference: aMethodReference definedBy: aCompiledMethod [
	^ self new
		objectName: aMethodReference methodSignature;
		definingMethodReference: (GtLMethodReference fromDefinitionOf: aCompiledMethod);
		yourself
]

{ #category : #accessing }
GtLMissingLocalMethodDomainObject >> defaultErrorMessage [
	definingMethodReference ifNil: [ ^ super defaultErrorMessage ].
	^ '{1} is not defined in its own class: it is {2}. Its source is {3}'
		format: {self missingObjectName.
				self reasonDescription.
				definingMethodReference methodSignature}
]

{ #category : #accessing }
GtLMissingLocalMethodDomainObject >> definingMethodReference [
	^ definingMethodReference
]

{ #category : #accessing }
GtLMissingLocalMethodDomainObject >> definingMethodReference: aMethodReference [
	definingMethodReference := aMethodReference
]

{ #category : #descriptions }
GtLMissingLocalMethodDomainObject >> definingMethodReferenceDescription [
	<magritteDescription>
	^ MAToOneRelationDescription new
		label: 'Defining method reference';
		accessor: #definingMethodReference;
		classes: {GtLMethodReference};
		beRequired
]

{ #category : #accessing }
GtLMissingLocalMethodDomainObject >> reasonDescription [
	^ self subclassResponsibility
]
