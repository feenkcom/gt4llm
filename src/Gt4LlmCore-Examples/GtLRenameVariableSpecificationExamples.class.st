"
I show the RenameInstanceVariable and RenameClassVariable transformations ({{gtClass:GtLRenameInstanceVariableSpecification}}, {{gtClass:GtLRenameClassVariableSpecification}}): their problems, their previews and what applying them does, on temporary classes with variables, accessors and a trait ({{gtMethod:GtLAbstractMagritteFunctionToolExamples>>#withDummyVariablesDo:}}).
"
Class {
	#name : #GtLRenameVariableSpecificationExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - apply' }
GtLRenameVariableSpecificationExamples >> applyRenames [
	"Applying renames of an instance variable, a class-side instance variable and a class variable renames them, keeps the values of the class side and rewrites the accessors, whose selectors do not change.
	The values of the instance variable in existing objects are not checked: after removing a slot, Pharo does not migrate the existing instances (Class>>#removeInstVarNamed:), so their values end up in other slots"

	<gtExample>
	^ self
		withDummyVariablesDo: [ :aRoot :aLeaf :aTrait | 
			| root rootClass classVariableGetter classSlotGetter objectStorage preview call |
			root := aRoot className asString.
			rootClass := aRoot realClass.
			classVariableGetter := aRoot classVariableNames first asString uncapitalized
					asSymbol.
			classSlotGetter := aRoot classSlotNames first asString asSymbol.
			rootClass perform: (classVariableGetter , ':') asSymbol with: 7.
			rootClass perform: (classSlotGetter , ':') asSymbol with: 3.
			objectStorage := GtLObjectStorage new.
			preview := self
					previewOf: {self
								renameInstanceVariableArguments: 'instVar1'
								to: 'renamedInstVar1'
								in: root
								classSide: false.
							self
								renameInstanceVariableArguments: classSlotGetter
								to: 'renamedClassSlot'
								in: root
								classSide: true.
							self
								renameClassVariableArguments: aRoot classVariableNames first asString
								to: 'RenamedClassVariable'
								in: root}
					in: objectStorage.
			call := self
					executeTool: GtLToolForApplyRefactoring new
					withArguments: (Dictionary new
							at: 'objectId' put: preview objectId;
							yourself)
					inContext: (GtLToolExecutionContext new objectStorage: objectStorage).
			self assert: (self modelOf: call) status equals: 'applied'.
			self assert: (rootClass instVarNames includes: #renamedInstVar1).
			self assert: (rootClass instVarNames includes: #instVar1) not.
			self
				assert: ((rootClass >> #instVar1) sourceCode includesSubstring: 'renamedInstVar1').
			self
				assert: rootClass classSide instVarNames asArray
				equals: #(#renamedClassSlot).
			self assert: (rootClass perform: classSlotGetter) equals: 3.
			self assert: rootClass classVarNames asArray equals: #(#RenamedClassVariable).
			self assert: (rootClass classPool at: #RenamedClassVariable) equals: 7.
			self assert: (rootClass perform: classVariableGetter) equals: 7.
			call ]
]

{ #category : #'examples - problems' }
GtLRenameVariableSpecificationExamples >> parameterProblemsOfRenameClassVariable [
	"A class variable name starts with an uppercase letter, and class variables belong to the class, not to its class side"

	<gtExample>
	<return: #Array>
	| problemOf |
	problemOf := [ :aClassName :aName :aNewName | 
		self
			problemOf: (self
					renameClassVariable: aName
					to: aNewName
					in: aClassName)
			kind: GtLTransformationParameterProblem ].
	self
		assert: (problemOf
				value: 'Object class'
				value: 'A'
				value: 'B')
		equals: 'Object class is the class side of Object: name Object, which defines the class variables of both sides'.
	self
		assert: (problemOf
				value: 'Object'
				value: 'A'
				value: 'lower')
		equals: 'lower is not a valid class variable name: it must start with an uppercase letter and contain only letters, digits and underscores'.
	^ {problemOf
			value: 'Object'
			value: 'A'
			value: 'lower'.
		problemOf
			value: 'Object'
			value: 'A'
			value: 'A'}
]

{ #category : #'examples - problems' }
GtLRenameVariableSpecificationExamples >> parameterProblemsOfRenameInstanceVariable [
	"Missing names, a class side named as a class, an unchanged name and a name that cannot name an instance variable are found from the arguments alone"

	<gtExample>
	<return: #Array>
	| problemOf |
	problemOf := [ :aClassName :aName :aNewName | 
		self
			problemOf: (self
					renameInstanceVariable: aName
					to: aNewName
					in: aClassName
					classSide: false)
			kind: GtLTransformationParameterProblem ].
	self
		assert: (problemOf
				value: ''
				value: 'a'
				value: 'b')
		equals: 'Missing class name'.
	self
		assert: (problemOf
				value: 'Object class'
				value: 'a'
				value: 'b')
		equals: 'Object class is the class side of Object: name Object and set classSide to true'.
	self
		assert: (problemOf
				value: 'Object'
				value: ''
				value: 'b')
		equals: 'Missing variable name'.
	self
		assert: (problemOf
				value: 'Object'
				value: 'a'
				value: '')
		equals: 'Missing new variable name'.
	self
		assert: (problemOf
				value: 'Object'
				value: 'a'
				value: 'a')
		equals: 'The new variable name is the current name of the variable: a'.
	^ #('Booking' 'self' 'two words' '1st')
		collect: [ :each | 
			| aProblem |
			aProblem := problemOf
					value: 'Object'
					value: 'a'
					value: each.
			self
				assert: aProblem
				equals: each
						, ' is not a valid instance variable name: it must start with a lowercase letter, contain only letters, digits and underscores, and not be a reserved name such as self'.
			aProblem ]
]

{ #category : #'examples - problems' }
GtLRenameVariableSpecificationExamples >> preconditionProblemsOfRenameClassVariable [
	"A class variable is renamed in the class that defines it, never in a trait. The new name must not be a variable of the hierarchy nor a global"

	<gtExample>
	^ self
		withDummyVariablesDo: [ :aRoot :aLeaf :aTrait | 
			| problemOf root leaf rootVariable |
			root := aRoot className asString.
			leaf := aLeaf className asString.
			rootVariable := aRoot classVariableNames first asString.
			problemOf := [ :aClassName :aName :aNewName | 
				self
					problemOf: (self
							renameClassVariable: aName
							to: aNewName
							in: aClassName)
					kind: GtLTransformationPreconditionProblem ].
			self
				assert: (problemOf
						value: aTrait className asString
						value: 'A'
						value: 'B')
				equals: aTrait className
						, ' is a trait: rename the class variables of a class'.
			self
				assert: (problemOf
						value: root
						value: 'NoSuchVariable'
						value: 'B')
				equals: root , ' has no class variable NoSuchVariable'.
			self
				assert: (problemOf
						value: leaf
						value: rootVariable
						value: 'B')
				equals: rootVariable , ' is defined in ' , root , ': rename it in ' , root.
			self
				assert: (problemOf
						value: root
						value: rootVariable
						value: aLeaf classVariableNames first asString)
				equals: aLeaf classVariableNames first , ' is already a variable of ' , leaf
						, ', in the hierarchy of ' , root.
			self
				assert: (problemOf
						value: root
						value: rootVariable
						value: 'Object')
				equals: 'Object is already the name of a class or global variable'.
			self
				assert: (self
						renameClassVariable: rootVariable
						to: 'RenamedClassVariable'
						in: root) gtProblems isEmpty.
			root ]
]

{ #category : #'examples - problems' }
GtLRenameVariableSpecificationExamples >> preconditionProblemsOfRenameInstanceVariable [
	"An instance variable is renamed in the class that defines it: an inherited one or one provided by a trait is refused with the class to rename it in. The new name must be free in the hierarchy, and, for a trait, in the hierarchies of the classes that use it"

	<gtExample>
	^ self
		withDummyVariablesDo: [ :aRoot :aLeaf :aTrait | 
			| problemOf root leaf trait rootSlot |
			root := aRoot className asString.
			leaf := aLeaf className asString.
			trait := aTrait className asString.
			rootSlot := aRoot classSlotNames first asString.
			problemOf := [ :aClassName :aName :aNewName :isClassSide | 
				self
					problemOf: (self
							renameInstanceVariable: aName
							to: aNewName
							in: aClassName
							classSide: isClassSide)
					kind: GtLTransformationPreconditionProblem ].
			self
				assert: (problemOf
						value: 'GtLNoSuchClassForRenames'
						value: 'a'
						value: 'b'
						value: false)
				equals: 'Class not found: GtLNoSuchClassForRenames'.
			self
				assert: (problemOf
						value: root
						value: 'noSuchVariable'
						value: 'b'
						value: false)
				equals: root , ' has no instance variable noSuchVariable'.
			self
				assert: (problemOf
						value: root
						value: 'instVar1'
						value: 'b'
						value: true)
				equals: root , ' class has no instance variable instVar1'.
			self
				assert: (problemOf
						value: leaf
						value: 'instVar1'
						value: 'b'
						value: false)
				equals: 'instVar1 is defined in ' , root , ': rename it in ' , root.
			self
				assert: (problemOf
						value: leaf
						value: rootSlot
						value: 'b'
						value: true)
				equals: rootSlot , ' is defined in ' , root , ' class: rename it in ' , root
						, ', with classSide true'.
			self
				assert: (problemOf
						value: root
						value: 'traitSlot1'
						value: 'b'
						value: false)
				equals: 'traitSlot1 is provided by the trait ' , trait , ': rename it in '
						, trait.
			self
				assert: (problemOf
						value: root
						value: 'instVar1'
						value: 'instVar3'
						value: false)
				equals: 'instVar3 is already an instance variable of ' , leaf
						, ', in the hierarchy of ' , root.
			self
				assert: (problemOf
						value: trait
						value: 'traitSlot1'
						value: 'instVar1'
						value: false)
				equals: 'instVar1 is already an instance variable of ' , root
						, ', in the hierarchy of ' , trait.
			self
				assert: (self
						renameInstanceVariable: 'instVar1'
						to: 'renamedInstVar1'
						in: root
						classSide: false) gtProblems isEmpty.
			self
				assert: (self
						renameInstanceVariable: rootSlot
						to: 'renamedClassSlot'
						in: root
						classSide: true) gtProblems isEmpty.
			root ]
]

{ #category : #private }
GtLRenameVariableSpecificationExamples >> previewOf: someTransformations in: anObjectStorage [
	"Preview the transformations with the previewRefactoring tool and return the stored preview"

	| call |
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (Dictionary new
					at: 'transformations' put: someTransformations asArray;
					yourself)
			inContext: (GtLToolExecutionContext new objectStorage: anObjectStorage).
	self assert: (self modelOf: call) class equals: GtLRefactoringPreview.
	^ self modelOf: call
]

{ #category : #'examples - previews' }
GtLRenameVariableSpecificationExamples >> previewRenameClassVariableAndClassSlot [
	"Two renames in one call: a class variable, used on the class side of the class and of its subclass, and a class-side instance variable. The preview is named and described by both"

	<gtExample>
	<return: #Array>
	^ self
		withDummyVariablesDo: [ :aRoot :aLeaf :aTrait | 
			| root rootVariable rootSlot preview |
			root := aRoot className asString.
			rootVariable := aRoot classVariableNames first asString.
			rootSlot := aRoot classSlotNames first asString.
			GtPharoCodeModifier current
				compileMethodSource: 'inheritedVariable' , String cr , String tab , '^ '
						, rootVariable
				in: aLeaf realClass classSide
				protocol: 'examples'.
			preview := self
					previewOf: {self
								renameClassVariableArguments: rootVariable
								to: 'RenamedClassVariable'
								in: root.
							self
								renameInstanceVariableArguments: rootSlot
								to: 'renamedClassSlot'
								in: root
								classSide: true}
					in: GtLObjectStorage new.
			self
				assert: preview refactoringName
				equals: 'Rename class variable, Rename instance variable'.
			self
				assert: preview refactoringDescription
				equals: 'Rename class variable ' , rootVariable , ' to RenamedClassVariable in ' , root
						, '; Rename instance variable ' , rootSlot , ' to renamedClassSlot in '
						, root , ' class'.
			self
				assert: ((preview changes select: [ :each | each kind beginsWith: 'renamed' ])
						collect: [ :each | each kind -> each target ]) asArray
				equals: {'renamed class variable' -> root.
						'renamed slot' -> (root , ' class')}.
			self
				assert: (preview changes
						anySatisfy: [ :each | each target = (aLeaf className , ' class>>#inheritedVariable') ]).
			self assert: (aRoot realClass classVarNames includes: rootVariable asSymbol).
			(preview changes collect: [ :each | each kind , ' ' , each target ]) asArray ]
]

{ #category : #'examples - previews' }
GtLRenameVariableSpecificationExamples >> previewRenameInstanceVariable [
	"The preview lists the renamed slot, then each method that refers to it, also in subclasses. Nothing is applied"

	<gtExample>
	<return: #Array>
	^ self
		withDummyVariablesDo: [ :aRoot :aLeaf :aTrait | 
			| root leaf preview |
			root := aRoot className asString.
			leaf := aLeaf className asString.
			GtPharoCodeModifier current
				compileMethodSource: 'instVar1Twice' , String cr , String tab
						, '^ instVar1 -> instVar1'
				in: aLeaf realClass
				protocol: 'examples'.
			preview := self
					previewOf: {self
								renameInstanceVariableArguments: 'instVar1'
								to: 'renamedInstVar1'
								in: root
								classSide: false}
					in: GtLObjectStorage new.
			self
				assert: preview refactoringDescription
				equals: 'Rename instance variable instVar1 to renamedInstVar1 in ' , root.
			self assert: preview changes first kind equals: 'renamed slot'.
			self assert: preview changes first target equals: root.
			self
				assert: (preview changes allButFirst collect: [ :each | each target ]) asSet
				equals: {root , '>>#instVar1'.
						root , '>>#instVar1:'.
						leaf , '>>#instVar1Twice'} asSet.
			self
				assert: (preview changes allButFirst
						allSatisfy: [ :each | 
							each kind = 'modified method'
								and: [ each newSource includesSubstring: 'renamedInstVar1' ] ]).
			self assert: (aRoot realClass instVarNames includes: #instVar1).
			(preview changes collect: [ :each | each kind , ' ' , each target ]) asArray ]
]

{ #category : #'examples - previews' }
GtLRenameVariableSpecificationExamples >> previewRenameTraitSlot [
	"A slot of a trait is renamed in the trait, with the methods of the trait that refer to it; the classes that use the trait get no methods of their own"

	<gtExample>
	<return: #Array>
	^ self
		withDummyVariablesDo: [ :aRoot :aLeaf :aTrait | 
			| trait preview |
			trait := aTrait className asString.
			preview := self
					previewOf: {self
								renameInstanceVariableArguments: 'traitSlot1'
								to: 'renamedTraitSlot'
								in: trait
								classSide: false}
					in: GtLObjectStorage new.
			self assert: preview changes first kind equals: 'renamed slot'.
			self assert: preview changes first target equals: trait.
			self
				assert: (preview changes allButFirst collect: [ :each | each target ]) asSet
				equals: {trait , '>>#traitSlot1'.
						trait , '>>#traitSlot1:'} asSet.
			(preview changes collect: [ :each | each kind , ' ' , each target ]) asArray ]
]

{ #category : #private }
GtLRenameVariableSpecificationExamples >> problemOf: aSpecification kind: aProblemClass [
	"Return the only problem of aSpecification, after checking its kind"

	| problems |
	problems := aSpecification gtProblems.
	self assert: problems size equals: 1.
	self assert: problems first class equals: aProblemClass.
	^ problems first description
]

{ #category : #'examples - problems' }
GtLRenameVariableSpecificationExamples >> renameAfterRenameClassIsRefused [
	"As every transformation on a renamed class, a variable rename comes before the RenameClass, with the current class name"

	<gtExample>
	<return: #Array>
	| rename problems |
	rename := GtLRenameClassSpecification new
			className: self class name;
			newClassName: self class name , 'Renamed';
			yourself.
	problems := (GtLCodeTransformations new
			transformations: {rename.
					self
						renameInstanceVariable: 'a'
						to: 'b'
						in: self class name
						classSide: false}) orderProblems.
	self assert: problems size equals: 1.
	self assert: problems first class equals: GtLTransformationPreconditionProblem.
	self
		assert: problems first description
		equals: 'RenameInstanceVariable on GtLRenameVariableSpecificationExamples comes after the RenameClass of GtLRenameVariableSpecificationExamples: put it before the RenameClass, with the current name'.
	^ problems
]

{ #category : #private }
GtLRenameVariableSpecificationExamples >> renameClassVariable: aName to: aNewName in: aClassName [
	^ GtLRenameClassVariableSpecification new
		variableClassName: aClassName;
		variableNameToRename: aName;
		newVariableName: aNewName;
		yourself
]

{ #category : #private }
GtLRenameVariableSpecificationExamples >> renameClassVariableArguments: aName to: aNewName in: aClassName [
	^ Dictionary new
		at: 'RenameClassVariable'
			put: (Dictionary new
					at: 'variableClassName' put: aClassName;
					at: 'variableNameToRename' put: aName;
					at: 'newVariableName' put: aNewName;
					yourself);
		yourself
]

{ #category : #'examples - problems' }
GtLRenameVariableSpecificationExamples >> renameInAnAddedClassIsRefused [
	"RB looks the class of a variable up when the refactoring is built, before an earlier AddClass of the same call has run: the variables of an added class get their names in the AddClass"

	<gtExample>
	<return: #Array>
	| problems |
	problems := (GtLCodeTransformations new
			transformations: {GtLAddClassSpecification new
						newClassName: 'GtLAddedClassForRenames';
						superclassName: 'Object';
						packageName: self class package name;
						slotNames: 'a';
						yourself.
					self
						renameInstanceVariable: 'a'
						to: 'b'
						in: 'GtLAddedClassForRenames'
						classSide: false}) gtProblems.
	self assert: problems size equals: 1.
	self assert: problems first class equals: GtLTransformationPreconditionProblem.
	self
		assert: problems first description
		equals: 'GtLAddedClassForRenames is added by an earlier transformation of the same call: give its variables their names when adding it'.
	^ problems
]

{ #category : #private }
GtLRenameVariableSpecificationExamples >> renameInstanceVariable: aName to: aNewName in: aClassName classSide: aBoolean [
	^ GtLRenameInstanceVariableSpecification new
		variableClassName: aClassName;
		classSide: aBoolean;
		variableNameToRename: aName;
		newVariableName: aNewName;
		yourself
]

{ #category : #private }
GtLRenameVariableSpecificationExamples >> renameInstanceVariableArguments: aName to: aNewName in: aClassName classSide: aBoolean [
	^ Dictionary new
		at: 'RenameInstanceVariable'
			put: (Dictionary new
					at: 'variableClassName' put: aClassName;
					at: 'classSide' put: aBoolean;
					at: 'variableNameToRename' put: aName;
					at: 'newVariableName' put: aNewName;
					yourself);
		yourself
]
