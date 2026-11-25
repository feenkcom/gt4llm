Class {
	#name : #GtLMethodTransformationSpecification,
	#superclass : #GtLCodeTransformationSpecification,
	#instVars : [
		'methodClassName',
		'classSide'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLMethodTransformationSpecification >> behaviorName [
	"The name of the class or metaclass of the method, as RB takes it: MyClass, or MyClass class"

	^ self behaviorNameOf: methodClassName
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> behaviorNameOf: aClassName [
	"The class or, for a class-side method, the metaclass named aClassName, as RB takes it"

	^ self classSide
		ifTrue: [ aClassName asString , ' class' ]
		ifFalse: [ aClassName asString ]
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> classSide [
	^ classSide = true
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> classSide: aBoolean [
	classSide := aBoolean
]

{ #category : #magritte }
GtLMethodTransformationSpecification >> classSideDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		comment: 'True for a method of the class side.';
		beRequired
]

{ #category : #validation }
GtLMethodTransformationSpecification >> gtProblemsWithMethodNamed: aSelector [
	"The method must be defined in the class itself, as for the method tools: a transformation of an inherited method or of a copy provided by a trait would not change the class"

	(self gtProblemsWithClassNamed: methodClassName)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	aSelector isEmptyOrNil
		ifTrue: [ ^ {GtLTransformationProblem description: 'Missing method name'} ].
	^ (self methodReferenceTo: aSelector)
		compiledMethodIfPresent: [ :aMethod | #() ]
		ifMissing: [ :anError | {GtLTransformationProblem description: anError errorMessage} ]
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> methodClassName [
	^ methodClassName
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> methodClassName: anObject [
	methodClassName := anObject
]

{ #category : #magritte }
GtLMethodTransformationSpecification >> methodClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #methodClassName;
		comment: 'The name of the class or trait, without " class": classSide tells the side.';
		beRequired
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> methodReferenceTo: aSelector [
	^ GtLMethodReference new
		methodClassName: methodClassName;
		methodName: aSelector asString;
		classSide: self classSide;
		yourself
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> usedClassNames [
	^ {methodClassName} reject: [ :each | each isNil ]
]
