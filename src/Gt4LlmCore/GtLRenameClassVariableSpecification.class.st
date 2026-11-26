"
I am the RenameClassVariable transformation of previewRefactoring. I rename a class variable with {{gtClass:RBRenameClassVariableRefactoring}}, as the Coder does ({{gtMethod:GtPharoRenameClassVariableRefactoringsStencil>>#computeRefactoring}}). The variable must be defined by the class itself, not inherited; traits are refused.
"
Class {
	#name : #GtLRenameClassVariableSpecification,
	#superclass : #GtLRenameVariableSpecification,
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLRenameClassVariableSpecification class >> isConcrete [
	^ true
]

{ #category : #converting }
GtLRenameClassVariableSpecification >> asRefactoringIn: aNamespace [
	"As the Coder does, see GtPharoRenameClassVariableRefactoringsStencil>>#computeRefactoring"

	^ RBRenameClassVariableRefactoring
		model: aNamespace
		rename: variableNameToRename asString
		to: newVariableName asString
		in: (aNamespace classNamed: variableClassName asSymbol)
]

{ #category : #validation }
GtLRenameClassVariableSpecification >> classSideNameProblemDescription [
	^ '{1} is the class side of {2}: name {2}, which defines the class variables of both sides'
		format: {variableClassName.
				self class instanceSideNameOf: variableClassName}
]

{ #category : #magritte }
GtLRenameClassVariableSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Renames the class variable variableNameToRename of variableClassName to newVariableName, and rewrites its references in the methods of both sides of the class and its subclasses. The class must define the variable itself, not inherit it. Accessors keep their selectors; comments and strings are not changed.';
		yourself
]

{ #category : #validation }
GtLRenameClassVariableSpecification >> invalidNameExplanation [
	^ ' is not a valid class variable name: it must start with an uppercase letter and contain only letters, digits and underscores'
]

{ #category : #validation }
GtLRenameClassVariableSpecification >> isValidVariableName: aString [
	"As the Coder checks it, see GtPharoRenameClassVariableValidator>>#validateVariableName:"

	^ aString notEmpty
		and: [ aString first isUppercase and: [ OCScanner isVariable: aString ] ]
]

{ #category : #validation }
GtLRenameClassVariableSpecification >> preconditionProblemsIn: aClass [
	"The class must define the variable itself. Neither its hierarchy may have a variable with the new name, as the Coder checks it (GtPharoRenameClassVariableCoderController>>#forbiddenNames), nor may a global have it"

	| aDefiningClass |
	aClass isTrait
		ifTrue: [ ^ {self
					preconditionProblem: aClass name , ' is a trait: rename the class variables of a class'} ].
	aDefiningClass := aClass withAllSuperclasses
			detect: [ :each | each classVarNames includes: variableNameToRename asSymbol ]
			ifNone: [ ^ {self
						preconditionProblem: aClass name , ' has no class variable ' , variableNameToRename} ].
	aDefiningClass = aClass
		ifFalse: [ ^ {self problemWithDefiningClass: aDefiningClass} ].
	aClass withAllSuperclasses , aClass allSubclasses
		detect: [ :each | 
			(each classVarNames includes: newVariableName asSymbol)
				or: [ each instVarNames includes: newVariableName asSymbol ] ]
		ifFound: [ :each | 
			^ {self
					preconditionProblem: ('{1} is already a variable of {2}, in the hierarchy of {3}'
							format: {newVariableName.
									each name.
									aClass name})} ].
	(Smalltalk globals includesKey: newVariableName asSymbol)
		ifTrue: [ ^ {self
					preconditionProblem: newVariableName , ' is already the name of a class or global variable'} ].
	^ #()
]

{ #category : #magritte }
GtLRenameClassVariableSpecification >> variableClassNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Class name';
		accessor: #variableClassName;
		comment: 'The name of the class that defines the class variable.';
		beRequired
]

{ #category : #accessing }
GtLRenameClassVariableSpecification >> variableKindName [
	^ 'class variable'
]
