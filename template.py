import yaml
from jinja2 import Environment, FileSystemLoader
from pathlib import Path
import shutil

TEMPLATES_DIR="templates/"
CONFIG_PATH="config.yaml"
RENDERED_DIR="dist/"

def get_config_data():
    parsed_yaml = open(CONFIG_PATH)
    return yaml.load(parsed_yaml, yaml.FullLoader)

def get_rendered_file_path(file_name):
    return f"{RENDERED_DIR}{file_name}"

def get_use_flag_str(use_flag_obj):
    added_flags = "" if use_flag_obj["add"] is None else " ".join(use_flag_obj["add"])
    removed_flags = "" if use_flag_obj["remove"] is None else "-" + " -".join(use_flag_obj["remove"])
    return added_flags + " " + removed_flags

def process_ebuild_repository_data(ebuild_repo_data):
    if ebuild_repo_data in (False, None):
        return False
    if ebuild_repo_data["certificate_file_name"] is not None:
        ebuild_repo_data["cert_required"] = True
        ebuild_repo_data["cert_path"] = Path("./user_files/" + ebuild_repo_data["certificate_file_name"]).absolute()
    else:
        ebuild_repo_data["cert_required"] = False

def process_config(config_data):
    config_data["build"]["global_use_flags"] = get_use_flag_str(config_data["build"]["global_use_flags"])
    config_data["custom_ebuild_repository"] = process_ebuild_repository_data(config_data["custom_ebuild_repository"])
    return config_data

def get_renders_to_exclude(config_data):
    renders_to_exclude = []
    if config_data["custom_ebuild_repository"] is False:
        renders_to_exclude.append("ebuild-overlay")
    return renders_to_exclude

config_data = process_config(get_config_data())
renders_to_exclude = get_renders_to_exclude(config_data)

environment = Environment(loader=FileSystemLoader("templates/"))

template_names = environment.list_templates()

shutil.rmtree(RENDERED_DIR)

for template_name in template_names:
    template = environment.get_template(template_name)
    rendered = template.render(config_data)
    if template_name.startswith(tuple(renders_to_exclude)):
        continue
    rendered_file_path = get_rendered_file_path(template_name)
    parent_directory_path = Path(rendered_file_path).parent.absolute()
    Path(parent_directory_path).mkdir(parents=True, exist_ok=True)

    file_to_write = open(get_rendered_file_path(template_name), "w")
    file_to_write.write(rendered)
