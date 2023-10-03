/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "revision_name" {
  value       = local.revision_name
  description = "The name of the installed managed ASM revision."
}

output "wait" {
  value       = var.mesh_management != "MANAGEMENT_AUTOMATIC" ? module.cpr[0].wait : null
  description = "An output to use when depending on the ASM installation finishing when NOT using automated ASM management modes."
}
