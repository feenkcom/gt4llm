"
I am the abstract parent of the transformations that rename a variable of a class: {{gtClass:GtLRenameInstanceVariableSpecification}} and {{gtClass:GtLRenameClassVariableSpecification}}. variableClassName is the class that defines the variable. The rename rewrites the references in methods only: variables do not appear in Lepiter annotations, accessors keep their selectors, and comments and strings are not changed.
My subclasses tell the kind of variable, the rule for its name ({{gtMethod:GtLRenameVariableSpecification>>#isValidVariableName:}}) and what the refactoring expects of the code ({{gtMethod:GtLRenameVariableSpecification>>#preconditionProblemsIn:}}).
"
Class {
	#name : #GtLRenameVariableSpecification,
	#superclass : #GtLVariableTransformationSpecification,
	#instVars : [
		'variableNameToRename',
		'newVariableName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #accessing }
GtLRenameVariableSpecification >> behaviorName [
	"The name of the class or metaclass that defines the variable"

	^ variableClassName asString
]

{ #category : #validation }
GtLRenameVariableSpecification >> classSideNameProblemDescription [
	"Return the problem with a class name that names a class side, such as MyClass class"

	^ self subclassResponsibility
]

{ #category : #printing }
GtLRenameVariableSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Rename ';
		nextPutAll: self variableKindName;
		space;
		nextPutAll: (variableNameToRename ifNil: [ '<variable>' ]) asString;
		nextPutAll: ' to ';
		nextPutAll: (newVariableName ifNil: [ '<new name>' ]) asString;
		nextPutAll: ' in ';
		nextPutAll: (variableClassName ifNil: [ '<class>' ] ifNotNil: [ self behaviorName ])
]

{ #category : #validation }
GtLRenameVariableSpecification >> gtParameterProblems [
	(self parameterProblemsWithClassName: variableClassName)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	(variableClassName asString endsWith: ' class')
		ifTrue: [ ^ {self parameterProblem: self classSideNameProblemDescription} ].
	variableNameToRename isEmptyOrNil
		ifTrue: [ ^ {self parameterProblem: 'Missing variable name'} ].
	newVariableName isEmptyOrNil
		ifTrue: [ ^ {self parameterProblem: 'Missing new variable name'} ].
	newVariableName asString = variableNameToRename asString
		ifTrue: [ ^ {self
					parameterProblem: 'The new variable name is the current name of the variable: ' , newVariableName} ].
	(self isValidVariableName: newVariableName asString)
		ifFalse: [ ^ {self parameterProblem: newVariableName , self invalidNameExplanation} ].
	^ #()
]

{ #category : #validation }
GtLRenameVariableSpecification >> gtPreconditionProblems [
	"RB refuses an inherited variable with an error and a name used in the hierarchy with a misleading message, so check them first"

	| aClass |
	aClass := (Smalltalk globals classOrTraitNamed: variableClassName asString)
			ifNil: [ ^ {self preconditionProblem: 'Class not found: ' , variableClassName} ].
	^ self preconditionProblemsIn: aClass
]

{ #category : #validation }
GtLRenameVariableSpecification >> gtPreconditionProblemsAfterAdding: someClassNames [
	"RB looks the class up when the refactoring is built, before an earlier AddClass of the same call has run, so a class added by the call cannot be named"

	(someClassNames includes: variableClassName asString)
		ifTrue: [ ^ {self
					preconditionProblem: variableClassName
							, ' is added by an earlier transformation of the same call: give its variables their names when adding it'} ].
	^ self gtPreconditionProblems
]

{ #category : #validation }
GtLRenameVariableSpecification >> invalidNameExplanation [
	"Return what follows an invalid new name in its problem, such as ' is not a valid class variable name: ...'"

	^ self subclassResponsibility
]

{ #category : #validation }
GtLRenameVariableSpecification >> isValidVariableName: aString [
	"Return whether aString can name my kind of variable, from the name alone"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLRenameVariableSpecification >> newVariableName [
	^ newVariableName
]

{ #category : #accessing }
GtLRenameVariableSpecification >> newVariableName: aString [
	newVariableName := aString
]

{ #category : #magritte }
GtLRenameVariableSpecification >> newVariableNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New variable name';
		accessor: #newVariableName;
		comment: 'The new name of the variable.';
		beRequired
]

{ #category : #validation }
GtLRenameVariableSpecification >> preconditionProblemsIn: aClass [
	"Return the problems with renaming my variable of aClass, the class named variableClassName"

	^ self subclassResponsibility
]

{ #category : #validation }
GtLRenameVariableSpecification >> problemWithDefiningClass: aBehavior [
	"My variable is defined in aBehavior, not in the class that names it. Name the defining class as the parameters take it: without ' class', which classSide tells"

	| aDefinerName |
	aDefinerName := aBehavior instanceSide name asString
			, (aBehavior isClassSide ifTrue: [ ', with classSide true' ] ifFalse: [ '' ]).
	^ self
		preconditionProblem: ((aBehavior isTrait
				ifTrue: [ '{1} is provided by the trait {2}: rename it in {3}' ]
				ifFalse: [ '{1} is defined in {2}: rename it in {3}' ])
				format: {variableNameToRename.
						aBehavior name.
						aDefinerName})
]

{ #category : #accessing }
GtLRenameVariableSpecification >> variableKindName [
	"Return the kind of variable I rename, such as 'instance variable'"

	^ self subclassResponsibility
]

{ #category : #accessing }
GtLRenameVariableSpecification >> variableNameToRename [
	^ variableNameToRename
]

{ #category : #accessing }
GtLRenameVariableSpecification >> variableNameToRename: aString [
	variableNameToRename := aString
]

{ #category : #magritte }
GtLRenameVariableSpecification >> variableNameToRenameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Variable name to rename';
		accessor: #variableNameToRename;
		comment: 'The current name of the variable.';
		beRequired
]
