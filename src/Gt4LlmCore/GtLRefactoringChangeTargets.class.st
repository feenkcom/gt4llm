"
I collect the code entities (methods and classes) affected by a refactoring change tree, before the change is applied.

RB changes describe only their target state and compute their diffs from the live image, so they cannot tell what changed once they are applied. I record which methods and classes they touch, so that snapshots of these entities can be taken before and after applying the changes (see {{gtClass:GtLCodeSnapshot}}).

The change classes add themselves through `#gtLlmAddChangeTargetsTo:`. A removed class also contributes its subclasses and all their local methods, so that the removed methods can be reported. Class renames are recorded so that the snapshot taken after applying the changes looks up a renamed class under its new name.

Use {{gtMethod:GtLRefactoringChangeTargets class>>#forChange:}} to collect the targets of a change.
"
Class {
	#name : #GtLRefactoringChangeTargets,
	#superclass : #Object,
	#instVars : [
		'methodReferences',
		'classNames',
		'classRenames'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringChangeTargets class >> forChange: aRefactoryChange [
	"Collect the methods and classes affected by aRefactoryChange.
	This must be done before the change is applied."

	^ self new
		addTargetsOfChange: aRefactoryChange;
		yourself
]

{ #category : #adding }
GtLRefactoringChangeTargets >> addClassNamed: aClassName [
	"Add the instance side class named aClassName, unless it is already present"

	| aString |
	aClassName ifNil: [ ^ self ].
	aString := aClassName asString.
	(classNames includes: aString) ifFalse: [ classNames add: aString ]
]

{ #category : #adding }
GtLRefactoringChangeTargets >> addMethodNamed: aSelector inClassNamed: aClassName isMeta: aBoolean [
	"Add the method and its (instance side) class"

	| aReference |
	(aSelector isNil or: [ aClassName isNil ]) ifTrue: [ ^ self ].
	aReference := GtLMethodReference new
			methodClassName: aClassName asString;
			methodName: aSelector asString;
			classSide: aBoolean = true;
			yourself.
	(methodReferences includes: aReference)
		ifFalse: [ methodReferences add: aReference ].
	self addClassNamed: aClassName
]

{ #category : #adding }
GtLRefactoringChangeTargets >> addRemovedClassNamed: aClassName [
	"Add a class that is going to be removed, together with its subclasses
	and all their local methods on both sides, so that the removed methods can be reported"

	| aClass |
	self addClassNamed: aClassName.
	aClass := Smalltalk globals classNamed: aClassName asString.
	(aClass notNil and: [ aClass isBehavior ]) ifFalse: [ ^ self ].
	aClass instanceSide withAllSubclasses
		do: [ :eachClass | 
			self addClassNamed: eachClass name.
			{eachClass.
				eachClass classSide}
				do: [ :eachBehavior | 
					eachBehavior localSelectors asSortedCollection
						do: [ :eachSelector | 
							self
								addMethodNamed: eachSelector
								inClassNamed: eachClass name
								isMeta: eachBehavior isClassSide ] ] ]
]

{ #category : #adding }
GtLRefactoringChangeTargets >> addTargetsOfChange: aRefactoryChange [
	aRefactoryChange gtLlmAddChangeTargetsTo: self
]

{ #category : #accessing }
GtLRefactoringChangeTargets >> classNameAfterChangesFor: aClassName [
	"Return the name under which the class named aClassName exists once the changes are applied"

	| aName visited |
	aName := aClassName asString.
	visited := Set new.
	[ (classRenames includesKey: aName) and: [ (visited includes: aName) not ] ]
		whileTrue: [ visited add: aName.
			aName := classRenames at: aName ].
	^ aName
]

{ #category : #accessing }
GtLRefactoringChangeTargets >> classNames [
	"Return the names (as known before applying the changes) of the affected classes"

	^ classNames
]

{ #category : #accessing }
GtLRefactoringChangeTargets >> classRenames [
	"Return a dictionary mapping old class names to new class names"

	^ classRenames
]

{ #category : #views }
GtLRefactoringChangeTargets >> gtTargetsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Targets';
		priority: 10;
		items: [ (classNames
				collect: [ :each | 
					'Class'
						-> ((classRenames includesKey: each)
								ifTrue: [ each , ' -> ' , (self classNameAfterChangesFor: each) ]
								ifFalse: [ each ]) ])
				, (methodReferences collect: [ :each | 'Method' -> each methodSignature ]) ];
		column: 'Kind'
			text: [ :each | each key ]
			width: 80;
		column: 'Target' text: [ :each | each value ]
]

{ #category : #initialization }
GtLRefactoringChangeTargets >> initialize [
	super initialize.
	methodReferences := OrderedCollection new.
	classNames := OrderedCollection new.
	classRenames := Dictionary new
]

{ #category : #testing }
GtLRefactoringChangeTargets >> isEmpty [
	^ methodReferences isEmpty and: [ classNames isEmpty ]
]

{ #category : #accessing }
GtLRefactoringChangeTargets >> methodReferences [
	"Return the references (as known before applying the changes) of the affected methods"

	^ methodReferences
]

{ #category : #printing }
GtLRefactoringChangeTargets >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream
				print: methodReferences size;
				nextPutAll: ' methods, ';
				print: classNames size;
				nextPutAll: ' classes' ]
]

{ #category : #adding }
GtLRefactoringChangeTargets >> renameClassNamed: anOldName to: aNewName [
	"Record a class rename, so that the snapshot taken after applying the changes
	looks the class (and its methods) up under the new name"

	(anOldName isNil or: [ aNewName isNil ]) ifTrue: [ ^ self ].
	classRenames at: anOldName asString put: aNewName asString.
	self addClassNamed: anOldName
]

{ #category : #snapshots }
GtLRefactoringChangeTargets >> snapshotAfterChanges [
	"Take a snapshot of the affected methods and classes, looking renamed classes up under their new names.
	Call me after applying the changes."

	^ GtLCodeSnapshot
		forTargets: self
		classNameMapping: [ :aClassName | self classNameAfterChangesFor: aClassName ]
]

{ #category : #snapshots }
GtLRefactoringChangeTargets >> snapshotBeforeChanges [
	"Take a snapshot of the affected methods and classes under their current names.
	Call me before applying the changes."

	^ GtLCodeSnapshot
		forTargets: self
		classNameMapping: [ :aClassName | aClassName ]
]
