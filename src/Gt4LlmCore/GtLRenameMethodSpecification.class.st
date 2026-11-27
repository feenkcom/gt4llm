"
I am the RenameMethod transformation of previewRefactoring, also used by the renameMethod tool ({{gtClass:GtLMagritteToolForMethodRename}}). I rename a method with {{gtClass:GtRBRenameMethodRefactoring}}.
The rename is global: the refactoring renames every implementor of the selector in the image, in any class, and rewrites all its senders, symbols such as #foo included, and the Lepiter snippets that mention the selector, in all databases. The class I am given names one implementor, the method to start from. Strings and comments are not changed. My preview lists the changes in the method and Lepiter groups ({{gtMethod:GtLRenameMethodSpecification>>#changeGroupNames}}).
The refactoring engine checks neither the number of arguments nor the trait compositions, and its other refusals do not say which class is the problem, so {{gtMethod:GtLRenameMethodSpecification>>#gtParameterProblems}} and {{gtMethod:GtLRenameMethodSpecification>>#gtPreconditionProblems}} check them first.
"
Class {
	#name : #GtLRenameMethodSpecification,
	#superclass : #GtLMethodTransformationSpecification,
	#instVars : [
		'methodNameToRename',
		'newMethodName'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLRenameMethodSpecification class >> isConcrete [
	^ true
]

{ #category : #accessing }
GtLRenameMethodSpecification class >> jsonSchemaLabel [
	^ 'RenameMethod'
]

{ #category : #private }
GtLRenameMethodSpecification >> argumentsDescriptionOf: aSelector [
	| aCount |
	aCount := aSelector asString numArgs.
	^ aCount = 1
		ifTrue: [ '1 argument' ]
		ifFalse: [ aCount printString , ' arguments' ]
]

{ #category : #converting }
GtLRenameMethodSpecification >> asRefactoringIn: aNamespace [
	"GtRBRenameMethodRefactoring also renames the selector in Lepiter snippets. The arguments keep their order"

	| oldSelector |
	oldSelector := methodNameToRename asSymbol.
	^ GtRBRenameMethodRefactoring
		model: aNamespace
		renameMethod: oldSelector
		in: (aNamespace classNamed: self behaviorName asSymbol)
		to: newMethodName asSymbol
		permutation: (1 to: oldSelector numArgs) asArray
]

{ #category : #private }
GtLRenameMethodSpecification >> behaviorsSharingMethodsOf: aBehavior [
	"Return aBehavior and, for a trait, the classes and traits that get its methods"

	aBehavior isTrait ifFalse: [ ^ {aBehavior} ].
	^ {aBehavior}
		, (aBehavior users asArray
				flatCollect: [ :each | self behaviorsSharingMethodsOf: each ])
]

{ #category : #accessing }
GtLRenameMethodSpecification >> changeGroupNames [
	"A method rename can change many methods and Lepiter snippets"

	^ #('methodChanges' 'lepiterChanges')
]

{ #category : #validation }
GtLRenameMethodSpecification >> clashProblems [
	"The refactoring refuses the rename when the new selector is already defined in the hierarchy of an implementor, as the renamed method would override that method or be overridden by it, but its message names an arbitrary class. Check it for all the implementors: the rename changes them all"

	| newSelector clashes listed |
	newSelector := newMethodName asSymbol.
	clashes := OrderedCollection new.
	self implementorsToRename
		do: [ :anImplementor | 
			(self definerOf: newSelector inHierarchyOf: anImplementor)
				ifNotNil: [ :aDefiner | clashes add: anImplementor -> aDefiner ] ].
	clashes ifEmpty: [ ^ #() ].
	listed := (clashes first: (clashes size min: 5))
			collect: [ :each | each key name , ' (' , newMethodName , ' in ' , each value name , ')' ].
	clashes size > 5 ifTrue: [ listed := listed copyWith: '...' ].
	^ {self
			preconditionProblem: ('{1} is already defined in the hierarchy of {2} of {3}, which the rename renames: {4}. The renamed methods would override these methods or be overridden by them'
					format: {newMethodName.
							clashes size = 1
								ifTrue: [ 'an implementor' ]
								ifFalse: [ clashes size printString , ' implementors' ].
							methodNameToRename.
							', ' join: listed})}
]

{ #category : #private }
GtLRenameMethodSpecification >> definerOf: aSelector inHierarchyOf: anImplementor [
	"Return the behavior that defines aSelector in the hierarchy of anImplementor: the nearest of anImplementor and its superclasses, else a subclass, also through a trait. Return nil if there is none"

	(self behaviorsSharingMethodsOf: anImplementor)
		do: [ :aBehavior | 
			(aBehavior lookupSelector: aSelector)
				ifNotNil: [ :aMethod | ^ aMethod methodClass ].
			(aBehavior allSubclasses
				detect: [ :each | each includesSelector: aSelector ]
				ifNone: [ nil ]) ifNotNil: [ :aSubclass | ^ aSubclass ] ].
	^ nil
]

{ #category : #magritte }
GtLRenameMethodSpecification >> descriptionContainer [
	^ super descriptionContainer
		comment: 'Renames the method methodNameToRename of methodClassName, or of its class side when classSide is true, to newMethodName, which must take the same number of arguments. The rename is global: it renames every implementor of the selector in all classes, not only in methodClassName and its hierarchy, and rewrites all its senders, including symbols such as #foo, and all the Lepiter snippets that mention it. Strings and comments are not changed. Put the other transformations on the method before the RenameMethod, with its current name. A preview with a RenameMethod lists its changes in groups: methodChanges and lepiterChanges.';
		yourself
]

{ #category : #printing }
GtLRenameMethodSpecification >> gtDisplayOn: aStream [
	aStream
		nextPutAll: 'Rename method ';
		nextPutAll: (methodClassName ifNil: [ '<class>' ] ifNotNil: [ self behaviorName ]);
		nextPutAll: '>>#';
		nextPutAll: (methodNameToRename ifNil: [ '<selector>' ]) asString;
		nextPutAll: ' to ';
		nextPutAll: (newMethodName ifNil: [ '<new selector>' ]) asString
]

{ #category : #validation }
GtLRenameMethodSpecification >> gtParameterProblems [
	(self parameterProblemsWithMethodNamed: methodNameToRename)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	newMethodName isEmptyOrNil
		ifTrue: [ ^ {self parameterProblem: 'Missing new method name'} ].
	newMethodName asString = methodNameToRename asString
		ifTrue: [ ^ {self
					parameterProblem: 'The new method name is the current name of the method: ' , newMethodName} ].
	{methodNameToRename.
		newMethodName}
		do: [ :aName | 
			(OCScanner isSelector: aName asString)
				ifFalse: [ ^ {self parameterProblem: aName , ' is not a valid method name'} ] ].
	newMethodName asString numArgs = methodNameToRename asString numArgs
		ifFalse: [ ^ {self
					parameterProblem: ('{1} takes {2} and {3} takes {4}: a rename keeps the arguments, so the new method name must take as many'
							format: {methodNameToRename.
									self argumentsDescriptionOf: methodNameToRename.
									newMethodName.
									self argumentsDescriptionOf: newMethodName})} ].
	^ #()
]

{ #category : #validation }
GtLRenameMethodSpecification >> gtPreconditionProblems [
	"The method must be defined in the class itself. Then check what the refactoring would refuse with a message that does not name the class, or would accept and break: see my class comment"

	(self preconditionProblemsWithMethodNamed: methodNameToRename)
		ifNotEmpty: [ :someProblems | ^ someProblems ].
	^ self clashProblems , self traitCompositionProblems
]

{ #category : #private }
GtLRenameMethodSpecification >> implementorsToRename [
	"Return the behaviors that define the method to rename themselves, the given one first: the refactoring renames them all. Copies of trait methods are left out: they follow their trait"

	| aBehavior others |
	aBehavior := (self methodReferenceTo: methodNameToRename)
			compiledMethodIfPresent: [ :aMethod | aMethod methodClass ]
			ifMissing: [ :anError | ^ #() ].
	others := ((SystemNavigation default
			allImplementorsOf: methodNameToRename asSymbol)
			reject: [ :each | each isFromTrait ]) collect: [ :each | each methodClass ].
	^ {aBehavior} , (others reject: [ :each | each == aBehavior ])
]

{ #category : #accessing }
GtLRenameMethodSpecification >> methodNameToRename [
	^ methodNameToRename
]

{ #category : #accessing }
GtLRenameMethodSpecification >> methodNameToRename: aString [
	methodNameToRename := aString
]

{ #category : #magritte }
GtLRenameMethodSpecification >> methodNameToRenameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Method name to rename';
		accessor: #methodNameToRename;
		comment: 'The current selector of the method, such as foo or at:put:.';
		beRequired
]

{ #category : #accessing }
GtLRenameMethodSpecification >> newMethodName [
	^ newMethodName
]

{ #category : #accessing }
GtLRenameMethodSpecification >> newMethodName: aString [
	newMethodName := aString
]

{ #category : #magritte }
GtLRenameMethodSpecification >> newMethodNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'New method name';
		accessor: #newMethodName;
		comment: 'The new selector. It must take the same number of arguments as the current one.';
		beRequired
]

{ #category : #private }
GtLRenameMethodSpecification >> selectorsNamedByComposition: aComposition [
	"Return the selectors that the aliases and exclusions of aComposition name, such as #a, #b and #c in T @ {#a -> #b} - {#c}"

	| selectors |
	selectors := Set new.
	aComposition isTraitAlias
		ifTrue: [ aComposition aliases
				keysAndValuesDo: [ :anAlias :aSelector | 
					selectors
						add: anAlias;
						add: aSelector ] ].
	aComposition isTraitExclusion
		ifTrue: [ selectors addAll: aComposition removedSelectors ].
	(aComposition isKindOf: TaSequence)
		ifTrue: [ aComposition members
				do: [ :each | selectors addAll: (self selectorsNamedByComposition: each) ] ].
	(aComposition isKindOf: TaSingleComposition)
		ifTrue: [ selectors addAll: (self selectorsNamedByComposition: aComposition inner) ].
	^ selectors
]

{ #category : #validation }
GtLRenameMethodSpecification >> traitCompositionProblems [
	"The refactoring does not change trait compositions: after the rename, an alias or an exclusion of the selector would still name the old selector"

	| aSelector users |
	aSelector := methodNameToRename asSymbol.
	users := (Smalltalk globals allClassesAndTraits
			flatCollect: [ :each | 
				{each instanceSide.
					each classSide} ])
			select: [ :each | 
				each hasTraitComposition
					and: [ (self selectorsNamedByComposition: each traitComposition) includes: aSelector ] ].
	users ifEmpty: [ ^ #() ].
	^ {self
			preconditionProblem: ('The trait compositions of {1} alias or exclude {2}, and the rename does not change trait compositions. Change these compositions first'
					format: {', ' join: (users collect: [ :each | each name ]).
							methodNameToRename})}
]
