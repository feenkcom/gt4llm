Class {
	#name : #GtLMethodWithSourceExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : 'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLMethodWithSourceExamples >> methodWithSourceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodObject |
	methodObject := GtLMethodWithSource
		fromCompiledMethod: (GtLMethodReference class>>#fromCompiledMethod:).

	self
		assert: methodObject methodName
		equals: #fromCompiledMethod:.
	self
		assert: methodObject methodClassName
		equals: #GtLMethodReference.
	self
		assert: methodObject isClassSide
		equals: true.
	self
		assert: methodObject methodClass
		equals: GtLMethodReference class.
	self
		assert: methodObject compiledMethod
		equals: (GtLMethodReference class>>#fromCompiledMethod:).
	self
		assert: methodObject sourceCode
		equals: (GtLMethodReference class>>#fromCompiledMethod:) sourceCode.

	^ methodObject
]

{ #category : #examples }
GtLMethodWithSourceExamples >> methodWithSourceObjectFromCompiledMethodClassSideJsonExport [
	<gtExample>
	| methodObject jsonObject |
	methodObject := self methodWithSourceObjectFromCompiledMethodClassSide.
	jsonObject := GtMagritteJSONDataExporter exportObject: methodObject.
	self
		assert: jsonObject
		equals: ((NeoJSONObject new)
			at: 'methodReference' put: ((NeoJSONObject new)
				at: 'methodName' put: 'fromCompiledMethod:';
				at: 'methodClassName' put: 'GtLMethodReference';
				at: 'classSide' put: true;
				yourself);
			at: 'sourceCode' put: (GtLMethodReference class>>#fromCompiledMethod:) sourceCode;
			yourself).

	^ jsonObject
]
