Class {
	#name : #GtLToolForPreviewRewrite,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #descriptions }
GtLToolForPreviewRewrite >> classNameDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Class name';
		accessor: #className;
		comment: 'The class whose instance- and class-side methods are rewritten. May be empty when packageName is given.';
		beRequired
]

{ #category : #accessing }
GtLToolForPreviewRewrite >> description [
	^ 'Previews an AST rewrite (search and replace) on the methods of a class and/or a package using RBParseTreeRewriter pattern syntax, without applying it. Patterns use a backquote for variables (`var), `@ for any expression (`@expr), `# for literals and `. for statements. Set isMethodPattern to true when from and to are whole method patterns. Pass className, packageName or both; leave the other one empty. Pass the objectId from the result to applyRefactoring to execute the changes.

Each change in the result has a changeDescription, a kind (modified method for rewritten methods), a target (e.g. MyClass>>#baz) and the newSource of the rewritten method.

Example JSON arguments:
{"from": "`@receiver foo", "to": "`@receiver bar", "isMethodPattern": false, "className": "MyClass", "packageName": ""}

Example JSON response:
{"changes": [{"changeDescription": "Add MyClass>>#baz", "kind": "modified method", "target": "MyClass>>#baz", "newSource": "baz ^ self bar"}], "changesCount": 1, "objectId": "abc123", "applied": false}'
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> fromDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'From';
		accessor: #from;
		comment: 'The pattern to search for.';
		beRequired
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> isMethodPatternDescription [
	<magritteDescription>
	^(MABooleanDescription new)
		label: 'Is method pattern';
		accessor: #isMethodPattern;
		comment: 'True when from and to are whole method patterns.';
		beRequired
]

{ #category : #private }
GtLToolForPreviewRewrite >> methodsIn: aDictionary ifMissing: aBlock [
	| className packageName methods |
	className := (aDictionary at: 'className') trimBoth.
	packageName := (aDictionary at: 'packageName') trimBoth.
	(className isEmpty and: [packageName isEmpty])
		ifTrue: 
			[^aBlock value: ((GtLMissingArgumentDomainObject new)
						arguments: aDictionary;
						missingArgument: 'className or packageName')].
	methods := Set new.
	className ifNotEmpty: 
			[methods addAll: (self methodsOfClassNamed: className
						ifAbsent: [^aBlock value: (GtLMissingDomainObject new objectName: className)])].
	packageName ifNotEmpty: 
			[methods addAll: (self methodsOfPackageNamed: packageName
						ifAbsent: 
							[^aBlock value: (GtLMissingDomainObject new objectName: packageName)])].
	^methods asSortedCollection: [:a :b | a name <= b name]
]

{ #category : #private }
GtLToolForPreviewRewrite >> methodsOfClassNamed: aString ifAbsent: aBlock [
	| class |
	class := Smalltalk globals classNamed: aString.
	class ifNil: [^aBlock value].
	^class localMethods , class classSide localMethods
]

{ #category : #private }
GtLToolForPreviewRewrite >> methodsOfPackageNamed: aString ifAbsent: aBlock [
	^(self packageOrganizer packageNamed: aString ifAbsent: [^aBlock value])
		methods
]

{ #category : #accessing }
GtLToolForPreviewRewrite >> name [
	^'previewRewrite'
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> packageNameDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'Package name';
		accessor: #packageName;
		comment: 'The package whose methods are rewritten. May be empty when className is given.';
		beRequired
]

{ #category : #private }
GtLToolForPreviewRewrite >> previewNamespace: aNamespace inContext: anExecutionContext [
	| preview |
	preview := GtLRefactoringPreview namespace: aNamespace.
	preview objectId: (anExecutionContext objectStorage addNewObject: preview
				reason: (GtLStoredObjectStringReason text: 'Rewrite preview')).
	^preview
]

{ #category : #execution }
GtLToolForPreviewRewrite >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments methods namespace |
	arguments := aToolCall arguments.
	#('from' 'to') do: 
			[:each |
			(arguments at: each) trimBoth isEmpty
				ifTrue: 
					[^(GtLMissingArgumentDomainObject new)
						arguments: arguments;
						missingArgument: each]].
	anExecutionContext objectStorage
		ifNil: 
			[^GtLMissingInformationDomainObject new missingModelName: 'objectStorage'].
	methods := self methodsIn: arguments
				ifMissing: [:aDomainObject | ^aDomainObject].
	namespace := [self rewrite: methods with: (self rewriterFor: arguments)]
				on: Error
				do: [:anError | ^GtLExceptionDomainObject freeze: anError].
	^self previewNamespace: namespace inContext: anExecutionContext
]

{ #category : #private }
GtLToolForPreviewRewrite >> rewrite: aCollection with: aRewriter [
	| namespace |
	namespace := GtRBNamespace new.
	aCollection do: 
			[:each |
			(aRewriter executeTree: each ast copy)
				ifTrue: [(namespace classFor: each methodClass) compileTree: aRewriter tree]].
	^namespace
]

{ #category : #private }
GtLToolForPreviewRewrite >> rewriterFor: aDictionary [
	| rewriter |
	rewriter := RBParseTreeRewriter new.
	(aDictionary at: 'isMethodPattern')
		ifTrue: 
			[rewriter replaceMethod: (aDictionary at: 'from')
				with: (aDictionary at: 'to')]
		ifFalse: 
			[rewriter replace: (aDictionary at: 'from') with: (aDictionary at: 'to')].
	^rewriter
]

{ #category : #descriptions }
GtLToolForPreviewRewrite >> toDescription [
	<magritteDescription>
	^(MAStringDescription new)
		label: 'To';
		accessor: #to;
		comment: 'The pattern that replaces each match.';
		beRequired
]
