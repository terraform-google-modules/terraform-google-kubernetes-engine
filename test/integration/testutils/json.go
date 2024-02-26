// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package testutils

import (
	"bytes"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/utils"
	"github.com/tidwall/gjson"
)

var (
	KubectlTransientErrors = []string{
		"E022[23] .* the server is currently unable to handle the request",
	}
)

// Filter transient errors from kubectl output
func ParseKubectlJSONResult(t testing.TB, s string) gjson.Result {
	bstring := []byte(s)

	for _, v := range KubectlTransientErrors {
		bstring = bytes.Replace(bstring, []byte(v), []byte(""), -1)
	}

	return utils.ParseJSONResult(t, string(bstring))
}
