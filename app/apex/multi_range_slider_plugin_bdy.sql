create or replace PACKAGE body multi_range_slider_plugin
IS
  FUNCTION render(
      p_region              IN apex_plugin.t_region,
      p_plugin              IN apex_plugin.t_plugin,
      p_is_printer_friendly IN BOOLEAN)
    RETURN apex_plugin.t_region_render_result
  IS
    -- Component attributes
    l_min apex_application_page_regions.attribute_01%type                   := COALESCE(p_region.attribute_01, '0');
    l_max apex_application_page_regions.attribute_02%type                   := COALESCE(p_region.attribute_02, '1440');
    l_step apex_application_page_regions.attribute_03%type                  := COALESCE(p_region.attribute_03, '30');
    l_gap apex_application_page_regions.attribute_04%type                   := COALESCE(p_region.attribute_04, '150');
    l_newlength apex_application_page_regions.attribute_05%type             := COALESCE(p_region.attribute_05, '90');
    l_handleLabelDispFormat apex_application_page_regions.attribute_06%type := COALESCE(p_region.attribute_06, 'function(steps) {var hours = Math.floor(Math.abs(steps) / 60); var minutes = Math.abs(steps) % 60; return ((hours < 10  >= 0) ? "0" : "") + hours + ":" + ((minutes < 10  >= 0) ? "0" : "") + minutes; }');
    l_stepLabelDispFormat apex_application_page_regions.attribute_07%type   := COALESCE(p_region.attribute_07, 'function(steps) {var hours = Math.floor(Math.abs(steps) / 60);return Math.abs(steps) % 60 === 0 ? ((hours < 10  >= 0) ? "0" : "") + hours : ""; }');
    --
    l_elementId apex_application_page_regions.attribute_08%type      := p_region.attribute_08;
    l_first_instance apex_application_page_regions.attribute_09%type := COALESCE(p_region.attribute_09, 'Y');
    l_options JSON                                                   := json();
    retval apex_plugin.t_region_render_result;
  BEGIN
    IF apex_application.g_debug THEN
      apex_plugin_util.debug_region(p_plugin => p_plugin, p_region => p_region);
    END IF;
    -- load the css and js only for first plugin instance
    IF l_first_instance = 'Y' THEN
      -- CSS files
      apex_css.add_file(p_name => 'vendor', p_directory => p_plugin.file_prefix);
      apex_css.add_file(p_name => 'main', p_directory => p_plugin.file_prefix);
      -- JS files
      apex_javascript.add_library(p_name => 'vendor', p_directory => p_plugin.file_prefix, p_version => NULL);
      apex_javascript.add_library(p_name => 'main', p_directory => p_plugin.file_prefix, p_version => NULL);
    END IF;
    -- html part
    sys.htp.p('<script>var ' || l_elementId || '</script>');
    sys.htp.p('<div id="content-' || l_elementId || '" class="content"><div id="' || l_elementId || '"></div></div>');
    --  plugin inicialization
    l_options.put(pair_name => 'min', pair_value => l_min);
    l_options.put(pair_name => 'max', pair_value => l_max);
    l_options.put(pair_name => 'step', pair_value => l_step);
    l_options.put(pair_name => 'gap', pair_value => l_gap);
    l_options.put(pair_name => 'newlength', pair_value => l_newlength);
    l_options.put(pair_name => 'handleLabelDispFormat', pair_value => l_handleLabelDispFormat);
    l_options.put(pair_name => 'stepLabelDispFormat', pair_value => l_stepLabelDispFormat);
    apex_javascript.add_onload_code(p_code => l_elementId || ' = new Mrs("' || l_elementId || '",' || l_options.to_char || ');');
    IF l_elementId = 'mrs1' THEN
      FOR rec IN
      (SELECT  *
      FROM PGIPAR_RANGES r
      WHERE r.PAR_RAN_DAY_MON = 'Y'
      AND r.PAR_RAN_DAY_WED   = 'Y'
      AND r.PAR_RAN_DAY_FRI   = 'Y'
      AND r.PAR_RAN_VACATION != 'Y'
      )
      LOOP
        apex_javascript.add_onload_code(p_code => l_elementId || '.addPeriods(' || '[['||rec.PAR_RAN_OPEN_FROM ||','|| (rec.PAR_RAN_OPEN_TO - rec.PAR_RAN_OPEN_FROM)||']]'|| ');');
      END LOOP;
    ELSIF l_elementId = 'mrs2' THEN
      FOR rec IN
      (SELECT  *
      FROM PGIPAR_RANGES r
      WHERE r.PAR_RAN_DAY_TUE = 'Y'
      AND r.PAR_RAN_DAY_THU   = 'Y'
      AND r.PAR_RAN_VACATION != 'Y'
      )
      LOOP
        apex_javascript.add_onload_code(p_code => l_elementId || '.addPeriods(' || '[['||rec.PAR_RAN_OPEN_FROM ||','|| (rec.PAR_RAN_OPEN_TO - rec.PAR_RAN_OPEN_FROM)||']]'|| ');');
      END LOOP;
    ELSIF l_elementId = 'mrs3' THEN
      FOR rec IN
      (SELECT * FROM PGIPAR_RANGES r WHERE r.PAR_RAN_VACATION = 'Y'
      )
      LOOP
        apex_javascript.add_onload_code(p_code => l_elementId || '.addPeriods(' || '[['||rec.PAR_RAN_OPEN_FROM ||','|| (rec.PAR_RAN_OPEN_TO - rec.PAR_RAN_OPEN_FROM)||']]'|| ');');
      END LOOP;
    END IF;
    RETURN retval;
  END render;
-- test
  PROCEDURE save_data(
      p_id   VARCHAR2,
      p_data VARCHAR2)
  IS
    all_ranges json_list;
    one_range json_list := json_list();
    l_open_from VARCHAR2(20);
    l_open_to   NUMBER;
  BEGIN
    all_ranges := json_list(p_data);
    IF p_id     = 'mrs1' THEN
      DELETE PGIPAR_RANGES r
      WHERE r.PAR_RAN_DAY_MON = 'Y'
      AND r.PAR_RAN_DAY_WED   = 'Y'
      AND r.PAR_RAN_DAY_FRI   = 'Y';
      FOR i IN 1..all_ranges.count
      LOOP
        one_range   := json_list(all_ranges.get(i));
        l_open_from := one_range.get(1).to_char;
        l_open_to   := l_open_from + one_range.get(2).to_char;
        INSERT
        INTO PGIPAR_RANGES
          (
            PAR_RAN_ORG_ID,
            PAR_RAN_OPEN_FROM,
            PAR_RAN_OPEN_TO,
            PAR_RAN_VACATION,
            PAR_RAN_DAY_MON,
            PAR_RAN_DAY_TUE,
            PAR_RAN_DAY_WED,
            PAR_RAN_DAY_THU,
            PAR_RAN_DAY_FRI,
            PAR_RAN_DAY_SAT,
            PAR_RAN_DAY_SUN,
            PAR_RAN_ACTIVE
          )
          VALUES
          (
            1,
            l_open_from,
            l_open_to,
            'N',
            'Y',
            'N',
            'Y',
            'N',
            'Y',
            'N',
            'N',
            'Y'
          );
      END LOOP;
    ElSIF p_id = 'mrs2' THEN
      DELETE PGIPAR_RANGES r
      WHERE r.PAR_RAN_DAY_TUE = 'Y'
      AND r.PAR_RAN_DAY_THU   = 'Y';
      FOR i IN 1..all_ranges.count
      LOOP
        one_range   := json_list(all_ranges.get(i));
        l_open_from := one_range.get(1).to_char;
        l_open_to   := l_open_from + one_range.get(2).to_char;
        INSERT
        INTO PGIPAR_RANGES
          (
            PAR_RAN_ORG_ID,
            PAR_RAN_OPEN_FROM,
            PAR_RAN_OPEN_TO,
            PAR_RAN_VACATION,
            PAR_RAN_DAY_MON,
            PAR_RAN_DAY_TUE,
            PAR_RAN_DAY_WED,
            PAR_RAN_DAY_THU,
            PAR_RAN_DAY_FRI,
            PAR_RAN_DAY_SAT,
            PAR_RAN_DAY_SUN,
            PAR_RAN_ACTIVE
          )
          VALUES
          (
            1,
            l_open_from,
            l_open_to,
            'N',
            'N',
            'Y',
            'N',
            'Y',
            'N',
            'N',
            'N',
            'Y'
          );
      END LOOP;
    ElSIF p_id = 'mrs3' THEN
      DELETE PGIPAR_RANGES r WHERE r.PAR_RAN_VACATION = 'Y';
      FOR i IN 1..all_ranges.count
      LOOP
        one_range   := json_list(all_ranges.get(i));
        l_open_from := one_range.get(1).to_char;
        l_open_to   := l_open_from + one_range.get(2).to_char;
        INSERT
        INTO PGIPAR_RANGES
          (
            PAR_RAN_ORG_ID,
            PAR_RAN_OPEN_FROM,
            PAR_RAN_OPEN_TO,
            PAR_RAN_VACATION,
            PAR_RAN_DAY_MON,
            PAR_RAN_DAY_TUE,
            PAR_RAN_DAY_WED,
            PAR_RAN_DAY_THU,
            PAR_RAN_DAY_FRI,
            PAR_RAN_DAY_SAT,
            PAR_RAN_DAY_SUN,
            PAR_RAN_ACTIVE
          )
          VALUES
          (
            1,
            l_open_from,
            l_open_to,
            'Y',
            'Y',
            'Y',
            'Y',
            'Y',
            'Y',
            'N',
            'N',
            'Y'
          );
      END LOOP;
    END IF;
  END;
END multi_range_slider_plugin;
/
