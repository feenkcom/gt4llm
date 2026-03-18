Class {
	#name : #GtLNotSourceSearchableMethodExamples,
	#superclass : #GtLMagritteDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples-Domain Objects'
}

{ #category : #examples }
GtLNotSourceSearchableMethodExamples >> methodWithNotSearchableSourceObjectFromCompiledMethodClassSide [
	<gtExample>
	| methodObject |
	methodObject := GtLNotSourceSearchableMethod
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
		equals: '<not searchable method>'.

	^ methodObject
]

{ #category : #examples }
GtLNotSourceSearchableMethodExamples >> methodWithNotSearchableSourceObjectFromCompiledMethodClassSideJsonExport [
	<gtExample>
	| methodObject jsonObject |
	methodObject := self methodWithNotSearchableSourceObjectFromCompiledMethodClassSide.
	jsonObject := GtMagritteJSONDataExporter exportObject: methodObject.
	self
		assert: jsonObject
		equals: ((NeoJSONObject new)
			at: 'methodReference' put: ((NeoJSONObject new)
				at: 'methodName' put: 'fromCompiledMethod:';
				at: 'methodClassName' put: 'GtLMethodReference';
				at: 'classSide' put: true;
				yourself);
			at: 'sourceCode' put: '<not searchable method>';
			yourself).

	^ jsonObject
]
