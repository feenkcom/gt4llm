"
I am a snapshot of the state of the methods and classes listed by a {{gtClass:GtLRefactoringChangeTargets}}.

For each method reference I store a {{gtClass:GtLMethodWithSource}} (or nil when the method does not exist) and for each class name a {{gtClass:GtLClassDefinitionDescription}} (or nil when the class does not exist). The keys are always the references and names known before applying the changes; a snapshot taken after applying them looks renamed classes up under their new name.

Two snapshots, one taken before and one after applying a refactoring, are compared by {{gtClass:GtLRefactoringCodeChangesBuilder}}.
"
Class {
	#name : #GtLCodeSnapshot,
	#superclass : #Object,
	#instVars : [
		'methods',
		'classes'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLCodeSnapshot class >> forTargets: aChangeTargets classNameMapping: aBlock [
	"Snapshot the methods and classes of aChangeTargets.
	aBlock maps a class name, as known before the changes, to the name under which the class is looked up"

	^ self new
		captureTargets: aChangeTargets classNameMapping: aBlock;
		yourself
]

{ #category : #initialization }
GtLCodeSnapshot >> captureTargets: aChangeTargets classNameMapping: aBlock [
	aChangeTargets classNames
		do: [ :eachClassName | 
			classes
				at: eachClassName
				put: ((self classNamed: (aBlock value: eachClassName))
						ifNotNil: [ :aClass | GtLClassDefinitionDescription fromClass: aClass ]) ].
	aChangeTargets methodReferences
		do: [ :eachReference | 
			methods
				at: eachReference
				put: ((self
						localMethodNamed: eachReference methodName
						inClassNamed: (aBlock value: eachReference methodClassName)
						classSide: eachReference isClassSide)
						ifNotNil: [ :aMethod | GtLMethodWithSource fromCompiledMethod: aMethod ]) ]
]

{ #category : #accessing }
GtLCodeSnapshot >> classAt: aClassName [
	"Return the GtLClassDefinitionDescription of the class, or nil if the class did not exist"

	^ classes at: aClassName asString ifAbsent: [ nil ]
]

{ #category : #private }
GtLCodeSnapshot >> classNamed: aClassName [
	"Return the instance side class named aClassName or nil if there is no such class"

	| aClass |
	aClass := Smalltalk globals classNamed: aClassName asString.
	(aClass notNil and: [ aClass isBehavior ]) ifFalse: [ ^ nil ].
	^ aClass instanceSide
]

{ #category : #accessing }
GtLCodeSnapshot >> classes [
	^ classes
]

{ #category : #views }
GtLCodeSnapshot >> gtEntriesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Snapshot';
		priority: 10;
		items: [ (classes associations sorted: [ :a :b | a key <= b key ])
				, (methods associations
						sorted: [ :a :b | a key methodSignature <= b key methodSignature ]) ];
		column: 'Entity'
			text: [ :each | each key isString ifTrue: [ each key ] ifFalse: [ each key methodSignature ] ];
		column: 'State'
			text: [ :each | each value ifNil: [ 'absent' ] ifNotNil: [ 'present' ] ]
			width: 80;
		send: [ :each | each value ]
]

{ #category : #initialization }
GtLCodeSnapshot >> initialize [
	super initialize.
	methods := Dictionary new.
	classes := Dictionary new
]

{ #category : #private }
GtLCodeSnapshot >> localMethodNamed: aSelector inClassNamed: aClassName classSide: aBoolean [
	"Return the method defined locally (not inherited) by the class or metaclass, or nil"

	| aBehavior |
	aBehavior := (self classNamed: aClassName) ifNil: [ ^ nil ].
	aBoolean ifTrue: [ aBehavior := aBehavior classSide ].
	^ aBehavior compiledMethodAt: aSelector asSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLCodeSnapshot >> methodAt: aMethodReference [
	"Return the GtLMethodWithSource of the method, or nil if the method did not exist"

	^ methods at: aMethodReference ifAbsent: [ nil ]
]

{ #category : #accessing }
GtLCodeSnapshot >> methods [
	^ methods
]
