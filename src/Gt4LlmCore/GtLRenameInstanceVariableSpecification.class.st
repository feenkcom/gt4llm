"
I am the RenameInstanceVariable transformation of previewRefactoring. I rename an instance variable (slot) of a class or trait, or of its class side, with {{gtClass:GtRenameInstanceVariableRefactoring}}, as the Coder does ({{gtMethod:GtPharoRenameInstanceVariableRefactoringsStencil>>#computeRefactoring}}). The variable must be defined by the class itself: an inherited variable or one provided by a trait is renamed where it is defined.
"
Class {
	#name : #GtLRenameInstanceVariableSpecification,
	#superclass : #GtLRenameVariableSpecification,
	#instVars : [
		'classSide'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLRenameInstanceVariableSpecification class >> isConcrete [
	^ true
]

{ #category : #converting }
GtLRenameInstanceVariableSpecification >> asRefactoringIn: aNamespace [
	"As the Coder does, see GtPharoRenameInstanceVariableRefactoringsStencil>>#computeRefactoring"

	| aModelClass |
	aModelClass := aNamespace classNamed: variableClassName asSymbol.
	self classSide ifTrue: [ aModelClass := aModelClass classSide ].
	^ GtRenameInstanceVariableRefactoring
		model: aNamespace
		rename: variableNameToRename asString
		to: newVariableName asString
		in: aModelClass
]

{ #category : #accessing }
GtLRenameInstanceVariableSpecification >> behaviorName [
	"The name of the class or metaclass that defines the variable: MyClass, or MyClass class"

	^ self classSide
		ifTrue: [ variableClassName asString , ' class' ]
		ifFalse: [ variableClassName asString ]
]

{ #category : #private }
GtLRenameInstanceVariableSpecification >> behaviorsSharingNamesWith: aBehavior [
	"The behaviors whose instance variables share their names with those of aBehavior: its superclasses and subclasses and, for a trait, the hierarchies of the classes that use it"

	| someBehaviors |
	someBehaviors := OrderedCollection new.
	someBehaviors
		addAll: aBehavior withAllSuperclasses;
		addAll: aBehavior allSubclasses.
	aBehavior isTrait
		ifTrue: [ aBehavior users
				do: [ :each | 
					someBehaviors
						addAll: each withAllSuperclasses;
						addAll: each allSubclasses ] ].
	^ someBehaviors
]

{ #category : #accessing }
GtLRenameInstanceVariableSpecification >> classSide [
	^ classSide = true
]

{ #category : #accessing }
GtLRenameInstanceVariableSpecification >> classSide: aBoolean [
	classSide := aBoolean
]

{ #category : #magritte }
GtLRenameInstanceVariableSpecification >> classSideDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Class side';
		accessor: #classSide;
		comment: 'True for an instance variable of the class side.';
		beRequired
]

{ #category : #validation }
GtLRenameInstanceVariableSpecification >> classSideNameProblemDescription [
	^ '{1} is the class side of {2}: name {2} and set classSide to true'
		format: {variableClassName.
				self class instanceSideNameOf: variableClassName}
]

{ #category : #magritte }
GtLRenameInstanceVariableSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Renames the instance variable variableNameToRename of variableClassName, or of its class side when classSide is true, to newVariableName, and rewrites its references in the methods of the class and its subclasses, or of the trait. The class must define the variable itself, not inherit it or get it from a trait. Accessors keep their selectors; comments and strings are not changed.';
		yourself
]

{ #category : #validation }
GtLRenameInstanceVariableSpecification >> invalidNameExplanation [
	^ ' is not a valid instance variable name: it must start with a lowercase letter, contain only letters, digits and underscores, and not be a reserved name such as self'
]

{ #category : #validation }
GtLRenameInstanceVariableSpecification >> isValidVariableName: aString [
	"The rule of RB, see ReIsValidInstanceVariableName>>#check"

	^ aString notEmpty
		and: [ (Symbol reservedLiterals includes: aString asSymbol) not
				and: [ aString first isUppercase not and: [ OCScanner isVariable: aString ] ] ]
]

{ #category : #validation }
GtLRenameInstanceVariableSpecification >> preconditionProblemsIn: aClass [
	"The variable must be defined by the class itself, as the method transformations require for a method. Neither its hierarchy nor, for a trait, the classes that use it may have a variable with the new name"

	| aBehavior aDefiningBehavior |
	aBehavior := self classSide ifTrue: [ aClass classSide ] ifFalse: [ aClass ].
	(aBehavior hasSlotNamed: variableNameToRename asSymbol)
		ifFalse: [ ^ {self
					preconditionProblem: aBehavior name , ' has no instance variable ' , variableNameToRename} ].
	aDefiningBehavior := (aBehavior slotNamed: variableNameToRename asSymbol)
			definingClass.
	aDefiningBehavior = aBehavior
		ifFalse: [ ^ {self problemWithDefiningClass: aDefiningBehavior} ].
	(self behaviorsSharingNamesWith: aBehavior)
		detect: [ :each | each instVarNames includes: newVariableName asSymbol ]
		ifFound: [ :each | 
			^ {self
					preconditionProblem: ('{1} is already an instance variable of {2}, in the hierarchy of {3}'
							format: {newVariableName.
									each name.
									aBehavior name})} ].
	^ #()
]

{ #category : #magritte }
GtLRenameInstanceVariableSpecification >> variableClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #variableClassName;
		comment: 'The name of the class or trait that defines the variable, without " class": classSide tells the side.';
		beRequired
]

{ #category : #accessing }
GtLRenameInstanceVariableSpecification >> variableKindName [
	^ 'instance variable'
]
