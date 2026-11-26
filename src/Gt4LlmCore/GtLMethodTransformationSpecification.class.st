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

{ #category : #validation }
GtLMethodTransformationSpecification >> parameterProblemsWithClassName: aString [
	"The class names of a method transformation leave out ' class': classSide tells the side"

	(super parameterProblemsWithClassName: aString)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	(aString asString endsWith: ' class')
		ifTrue: [ ^ {self
					parameterProblem: ('{1} is the class side of {2}: name {2} and set classSide to true'
							format: {aString.
									self class instanceSideNameOf: aString})} ].
	^ #()
]

{ #category : #validation }
GtLMethodTransformationSpecification >> parameterProblemsWithMethodNamed: aSelector [
	^ (self parameterProblemsWithClassName: methodClassName)
		, (aSelector isEmptyOrNil
				ifTrue: [ {self parameterProblem: 'Missing method name'} ]
				ifFalse: [ #() ])
]

{ #category : #validation }
GtLMethodTransformationSpecification >> preconditionProblemsWithMethodNamed: aSelector [
	"The method must be defined in the class itself, as for the method tools: a transformation of an inherited method or of a copy provided by a trait would not change the class"

	(self preconditionProblemsWithClassNamed: methodClassName)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	^ (self methodReferenceTo: aSelector)
		compiledMethodIfPresent: [ :aMethod | #() ]
		ifMissing: [ :anError | {self preconditionProblem: anError errorMessage} ]
]

{ #category : #accessing }
GtLMethodTransformationSpecification >> usedClassNames [
	^ {methodClassName} reject: [ :each | each isNil ]
]
