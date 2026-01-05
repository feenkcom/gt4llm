Class {
	#name : #GtMagritteJSONSchemaExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #assertions }
GtMagritteJSONSchemaExporterExamples >> assertSchema: aJsonSchema equals: aSchemString [
	self 
		assert: (STONJSON fromString: (NeoJSONWriter toStringPretty: aJsonSchema json) withInternalLineEndings)
		equals: (STONJSON fromString: aSchemString withInternalLineEndings)
]

{ #category : #expected }
GtMagritteJSONSchemaExporterExamples >> expectedSchemaStringForMathReasoningWithDelegatedType [
	^ '{
	"type" : "object",
	"properties" : {
		"steps" : {
			"type" : "array",
			"items" : {
				"type" : "object",
				"properties" : {
					"step" : {
						"anyOf" : [
							{
								"type" : "object",
								"properties" : {
									"content" : {
										"type" : "string",
										"description" : "An explanation of this step"
									}
								},
								"required" : [
									"content"
								],
								"additionalProperties" : false
							},
							{
								"type" : "object",
								"properties" : {
									"output" : {
										"type" : "string"
									}
								},
								"required" : [
									"output"
								],
								"additionalProperties" : false
							}
						]
					}
				},
				"required" : [
					"step"
				],
				"additionalProperties" : false
			}
		},
		"finalAnswer" : {
			"type" : "string"
		}
	},
	"required" : [
		"steps",
		"finalAnswer"
	],
	"additionalProperties" : false
}'
]

{ #category : #expected }
GtMagritteJSONSchemaExporterExamples >> expectedSchemaStringForMathReasoningWithMultipleTypes [
	^ '{
	"type" : "object",
	"properties" : {
		"steps" : {
			"type" : "array",
			"items" : {
				"anyOf" : [
					{
						"type" : "object",
						"properties" : {
							"content" : {
								"type" : "string",
								"description" : "An explanation of this step"
							}
						},
						"required" : [
							"content"
						],
						"additionalProperties" : false
					},
					{
						"type" : "object",
						"properties" : {
							"output" : {
								"type" : "string"
							}
						},
						"required" : [
							"output"
						],
						"additionalProperties" : false
					}
				]
			}
		},
		"finalAnswer" : {
			"type" : "string"
		}
	},
	"required" : [
		"steps",
		"finalAnswer"
	],
	"additionalProperties" : false
}'
]

{ #category : #expected }
GtMagritteJSONSchemaExporterExamples >> expectedSchemaStringForMathReasoningWithSingleType [
	^ '{
	"type" : "object",
	"description" : "Math reasoning is made out of steps.",
	"properties" : {
		"steps" : {
			"type" : "array",
			"items" : {
				"type" : "object",
				"properties" : {
					"output" : {
						"type" : "string"
					},
					"explanation" : {
						"type" : "string",
						"description" : "An explanation of this step"
					}
				},
				"required" : [
					"output",
					"explanation"
				],
				"additionalProperties" : false
			}
		},
		"finalAnswer" : {
			"type" : "string"
		}
	},
	"required" : [
		"steps",
		"finalAnswer"
	],
	"additionalProperties" : false
}'
]

{ #category : #generation }
GtMagritteJSONSchemaExporterExamples >> generateSchemaForMathReasoningWithDelegatedType [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter 
		forModelClass: GtLDemoMathReasoningWithDelegatedSteps.
	^ exporter exportSchema
]

{ #category : #generation }
GtMagritteJSONSchemaExporterExamples >> generateSchemaForMathReasoningWithMultipleTypes [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter 
		forModelClass: GtLDemoMathReasoningWithDifferentSteps.
	^ exporter exportSchema
]

{ #category : #generation }
GtMagritteJSONSchemaExporterExamples >> generateSchemaForMathReasoningWithSingleType [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter forModelClass: GtLDemoMathReasoning.
	^ exporter exportSchema
]

{ #category : #examples }
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithDelegatedType [
	<gtExample>
	self 
		assertSchema: self generateSchemaForMathReasoningWithDelegatedType
		equals: self expectedSchemaStringForMathReasoningWithDelegatedType
]

{ #category : #examples }
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithMultipleTypes [
	<gtExample>
	self  
		assertSchema: self generateSchemaForMathReasoningWithMultipleTypes
		equals: self expectedSchemaStringForMathReasoningWithMultipleTypes
]

{ #category : #examples }
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithSingleType [
	<gtExample>
	self 
		assertSchema: self generateSchemaForMathReasoningWithSingleType
		equals: self expectedSchemaStringForMathReasoningWithSingleType
]
