Class {
	#name : #GtMagritteJSONSchemaExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Magritte'
}

{ #category : #assertions }
GtMagritteJSONSchemaExporterExamples >> assertSchema: aJsonSchema equals: aSchemaString [
	| expectedSchema |
	expectedSchema := NeoJSONSchema new json: (NeoJSONObject fromString: aSchemaString).
	self 
		assert: aJsonSchema
		equals: expectedSchema.
		
	self 
		assert: aJsonSchema raw
		equals: expectedSchema raw.
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
GtMagritteJSONSchemaExporterExamples >> expectedSchemaStringForMathReasoningWithMultipleTypesWithContainer [
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
							"ExplanationStep" : {
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
							}
						},
						"required" : [
							"ExplanationStep"
						],
						"additionalProperties" : false
					},
					{
						"type" : "object",
						"properties" : {
							"OutputStep" : {
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
						},
						"required" : [
							"OutputStep"
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
					"explanation" : {
						"type" : "string",
						"description" : "An explanation of this step"
					},
					"output" : {
						"type" : "string"
					}
				},
				"required" : [
					"explanation",
					"output"
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
GtMagritteJSONSchemaExporterExamples >> generateSchemaForMathReasoningWithMultipleTypesWithContainer [
	| exporter |
	exporter := GtMagritteJSONSchemaExporter 
		forModelClass: GtLDemoMathReasoningWithDifferentStepsWithContainer.
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
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithMultipleTypesWithContainer [
	<gtExample>
	self  
		assertSchema: self generateSchemaForMathReasoningWithMultipleTypesWithContainer
		equals: self expectedSchemaStringForMathReasoningWithMultipleTypesWithContainer
]

{ #category : #examples }
GtMagritteJSONSchemaExporterExamples >> testSchemaGenerationForMathReasoningWithSingleType [
	<gtExample>
	self 
		assertSchema: self generateSchemaForMathReasoningWithSingleType
		equals: self expectedSchemaStringForMathReasoningWithSingleType
]
